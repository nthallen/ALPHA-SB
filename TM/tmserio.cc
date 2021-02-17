/** \file tmserio.cc
 * Telemetry transmitter and command receiver
 */
#include <fcntl.h>
#include <termios.h>
#include <string.h>
#include <errno.h>
#include "tmserio.h"
#include "dasio/appid.h"
#include "dasio/loop.h"
#include "crc16modbus.h"
#include "nl.h"
#include "nl_assert.h"


DAS_IO::AppID_t DAS_IO::AppID("tmserio",
  "Telemetry Serial I/O", "V1.0");

tmserio_if *tmserio_if::TMp = 0;
const char *tmserio_if::tm_port = "/dev/ttyS0";
const char *tmserio_if::base = "PNG";
uint32_t tmserio_if::cur_photo = 0;
int tmserio_if::baud = 115200;
int tmserio_if::air_speed = 125000;

tmserio_if::tmserio_if() :
    Serial("radio", max_cmd_packet_size),
    row_len(0),
    connect_waiting(false) {

  // scan_fd = -1;
  // cur_scan = next_scan = 0;
  // scan_nb = scan_cp = 0;
  // scan_mfctr = scan_mfctr_offset = 0;
  // Could add option to find scans in another directory, etc.
  // mlf = mlf_init(3, 60, 0, base, "dat", NULL);

  TMp = this;

  // This calculation is for telemetry data plus the header
  // If OOB data can be larger, the obufsize will need to change
  row_len = (tm_info.tm.nbminf-2)+sizeof(serio_pkt_hdr);
  set_obufsize(row_len);
  rows_per_row = (tm_info.tm.nsecsper * air_speed) /
        (tm_info.tm.nrowsper * row_len * 10);
  switch (rows_per_row) {
    case 0:
      msg(MSG_ERROR,
        "%s: TM data rate %d bps exceeds radio air speed %d bps",
        iname,
        (tm_info.tm.nrowsper * row_len * 10) / tm_info.tm.nsecsper,
        air_speed);
      break;
    case 1:
      msg(MSG_WARN,
        "%s: TM data rate %d bps does not allow for OOB data",
        iname,
        (tm_info.tm.nrowsper * row_len * 10) / tm_info.tm.nsecsper);
      break;
    case 2:
      msg(MSG, "%s: rows_per_row is %d", iname, rows_per_row);
      break;
  }
  connect();
}

void tmserio_if::connect() {
  if (fd < 0) {
    int old_response = set_response(NLRSP_QUIET);
    init(tm_port, O_RDWR | O_NONBLOCK);
    set_response(old_response);
    if (fd < 0) {
      if (!connect_waiting) {
        connect_waiting = true;
        msg(MSG_ERROR, "%s: Unable to open device %s: %s (%d)",
          iname, tm_port, strerror(errno), errno);
      }
      queue_retry();
    } else {
      msg(MSG, "%s: Successfully opened %s", iname, tm_port);
      setup(baud, 8, 'n', 1, 0, 0);
      hwflow_enable(true);
      flush_input();
      update_tc_vmin(min_cmd_packet_size,1);
      flags |= Fl_Read;
      if (!obuf_empty())
        flags |= Fl_Write;
    }
  }
  if (fd >= 0) {
    connect_waiting = false;
    TO.Clear();
    flags &= ~Fl_Timeout;
  }
}

void tmserio_if::queue_retry() {
  flags &= ~(Fl_Read | Fl_Write);
  flags |= Fl_Timeout;
  TO.Set(5, 0);
}

bool tmserio_if::protocol_timeout() {
  connect();
  return false;
}

bool tmserio_if::protocol_except() {
  msg(MSG_ERROR, "%s: protocol_except()", iname);
  close();
  return process_eof();
}

/**
 * @param MFCtr
 * @param raw The raw homerow data without the leading MFCtr or
 *    trailing Synch
 * @param Synch
 */
void tmserio_if::send_row(uint16_t MFCtr, const uint8_t *raw) {
  if (obuf_empty()) {
    struct iovec io[3];
    serio_pkt_hdr hdr;
    hdr.LRC = 0;
    hdr.type = pkt_type_TM;
    hdr.length = tm_info.tm.nbminf-2;
    io[0].iov_len = sizeof(serio_pkt_hdr);
    io[0].iov_base = &hdr;
    io[1].iov_len = sizeof(MFCtr);
    io[1].iov_base = &MFCtr;
    io[2].iov_len = tm_info.tm.nbminf - 4;
    io[2].iov_base = (void*)raw;
    // Calculate the CRC of io[1] and io[2]
    { unsigned CRC = crc16modbus_word(0,0,0);
      CRC = crc16modbus_word(CRC, io[1].iov_base, io[1].iov_len);
      CRC = crc16modbus_word(CRC, io[2].iov_base, io[2].iov_len);
      hdr.CRC = CRC;
      uint8_t *hdrp = (uint8_t *)io[0].iov_base;
      for (int i = 1; i < io[0].iov_len; ++i) {
        hdr.LRC += hdrp[i];
      }
      hdr.LRC = -hdr.LRC;
    }
    bool rv = iwritev(io, 3);
    rows_this_row = 0;
    // if (obuf_empty())
      // send_oob_data();
  }
}

#ifdef HAVE_SCAN_DATA
void tmserio_if::enqueue_scan(int32_t scannum) {
  next_scan = scannum;
}

/**
 */
void tmserio_if::send_scan_data() {
  while (rows_this_row < rows_per_row) {
    if (cur_scan == 0) {
      if (next_scan == 0) return;
      cur_scan = next_scan;
      next_scan = 0;
      mlf_set_index(mlf, cur_scan);
      scan_fd = mlf_next_fd(mlf);
      nl_error(MSG_DBG(0), "Reading scan %lu from path %s",
        cur_scan, mlf->fpath);
      if (scan_fd < 0) { // error is already reported
        cur_scan = 0;
        return;
      }
      scan_file_size = lseek(scan_fd, 0, SEEK_END);
      if (scan_file_size < 0 || lseek(scan_fd, 0, SEEK_SET) != 0) {
        nl_error(2, "Error getting scan %d length");
        close(scan_fd);
        scan_fd = -1;
        cur_scan = 0;
        return;
      }
      if (scan_file_size > scanbufsize) {
        nl_error(MSG_ERROR, "Scan %d size %lu exceeds max possible %d",
          cur_scan, scan_file_size, scanbufsize);
        close(scan_fd);
        scan_fd = -1;
        cur_scan = 0;
        return;
      }
      int rv = ::read(scan_fd, scanbuf, scan_file_size);
      if (rv < 0) {
        nl_error(MSG_ERROR, "Error %d reading scan %d", errno, cur_scan);
        close(scan_fd);
        scan_fd = -1;
        cur_scan = 0;
        return;
      }
      scan_nb = rv;
      if (rv < scan_file_size) {
        nl_error(MSG_WARN, "Short read on scan %d: %d/%d",
            cur_scan, rv, scan_file_size);
      }
      ssp_hdr = (ssp_scan_hdr_t *)scanbuf;
      int chk_size = sizeof(uint32_t)*(7+ssp_hdr->NChannels*ssp_hdr->NSamples);
      if (chk_size > scan_file_size) {
        nl_error(MSG_ERROR, "Scan file %d is short: %d/%d",
          cur_scan, scan_file_size, chk_size);
        close(scan_fd);
        scan_fd = -1;
        cur_scan = 0;
        return;
      } else if (chk_size < scan_file_size) {
        nl_error(MSG_DBG(0), "Scan file %d is long: %d/%d",
          cur_scan, scan_file_size, chk_size);
        scan_file_size = chk_size;
        if (scan_nb > scan_file_size)
          scan_nb = scan_file_size;
      }
      nl_error(MSG_DBG(0), "Transmitting scan %ld: %lu bytes",
        cur_scan, scan_file_size);
      scan_cp = 0;
      scan_mfctr = 0;
      scan_mfctr_offset = 1;
      scan_file_offset = scan_nb;
    }
    if (flush_row()) return;
    if (scan_mfctr < scan_mfctr_offset ||
        scan_mfctr > scan_mfctr_offset + 255) {
      // create a header
      scan_mfctr_offset = scan_mfctr;
      // row_buf->scan_hdr.scannum = cur_scan;
      // row_buf->scan_hdr.scansize = scan_file_size;
      // row_buf->scan_hdr.mfctr_offset = scan_mfctr++;
      // memset(&row_buf->row[sizeof(scan_hdr_t)], 0,
        // row_len-sizeof(scan_hdr_t)-3);
      // row_buf->row[row_len-3] = 0;
      // memcpy(&(row_buf->row[row_len-2]), &scan_synch, 2);
      // row_offset = 0;
      // if (flush_row()) return;
    }
    if (scan_nb - scan_cp < row_len-3 &&
        scan_file_offset < scan_file_size) {
      // Less than one row of data currently in scanbuf and
      // more data left in the file, so read in more.
      if (scan_nb > scan_cp && scan_cp > 0) {
        memmove(&(row_buf->row[0]), &(row_buf->row[scan_cp]), scan_nb-scan_cp);
        scan_nb -= scan_cp;
        scan_cp = 0;
      }
      int remaining = scan_file_size - scan_file_offset;
      int available = scanbufsize - scan_cp;
      if (remaining > available) {
        if (available > blocksize) {
          // round down to fixed number of blocks
          int blocks = available/blocksize;
          remaining = blocks*blocksize;
        } else {
          remaining = available;
          // This should really never happen. It would mean the
          // scanbufsize is not much bigger than the blocksize
        }
      }
      int rv = ::read(scan_fd, scanbuf+scan_cp, remaining);
      scan_nb += rv;
      scan_file_offset += rv;
    }
    if (scan_cp >= scan_nb) {
      nl_assert(scan_file_offset >= scan_file_size);
      nl_assert(scan_fd >= 0);
      close(scan_fd);
      scan_fd = -1;
      cur_scan = 0;
    } else {
      uint16_t row_mfc = scan_mfctr++ - scan_mfctr_offset;
      uint16_t hdr_offset = 0;
      // transmit a row
      int available = scan_nb - scan_cp;
      if (row_mfc == 0) {
        row_buf->scan_hdr.scannum = cur_scan;
        row_buf->scan_hdr.scansize = scan_file_size;
        row_buf->scan_hdr.mfctr_offset = scan_mfctr_offset;
        hdr_offset = sizeof(scan_hdr_t);
      }
      if (available >= row_len-3-hdr_offset) {
        available = row_len - 3 - hdr_offset;
        memcpy(&(row_buf->row[hdr_offset]), &scanbuf[scan_cp], available);
      } else {
        memcpy(&(row_buf->row[hdr_offset]), &scanbuf[scan_cp], available);
        memset(&(row_buf->row[hdr_offset+available]), 0,
          row_len - 3 - available - hdr_offset);
      }
      row_buf->row[row_len-3] = row_mfc;
      memcpy(&(row_buf->row[row_len-2]), &scan_synch, 2);
      scan_cp += available;
      row_offset = 0;
      if (flush_row()) return;
    }
  }
}

void set_cur_photo(uint32_t Photo_Num) {
  if (TMp) TMp->cur_photo = Photo_Num;
}
#endif

void tmserio_tm_client::adopted() {
  tmserio_if *radio = new tmserio_if();
  ELoop->add_child(radio);
}

void tmserio_tm_client::send_row(uint16_t MFCtr, const uint8_t *raw) {
  if (tmserio_if::TMp)
    tmserio_if::TMp->send_row(MFCtr, raw);
}
