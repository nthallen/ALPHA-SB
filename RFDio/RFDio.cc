#include <cstring>
#include "RFDio_int.h"
#include "dasio/loop.h"
#include "dasio/tm.h"
#include "crc16modbus.h"
#include "oui.h"
#include "nl.h"

using namespace DAS_IO;

const char *RFD_interface::RFD_port;
int RFD_interface::RFD_baud_rate = 57600;
bool RFD_interface::hwflow = true;

RFD_interface::RFD_interface(const char *name, serio_if *serio) :
    Serial(name, ibufsize),
    write_blocked(false),
    connect_waiting(false),
    recd_pkts_dropped(0),
    serio(serio)
{
  flags = Fl_Except;
  ::load_tmdac(".");
  connect();
}

void RFD_interface::tx_cmd(struct iovec *io, int n_iov) {
  iwritev(io, n_iov);
}

void RFD_interface::connect() {
  if (fd < 0) {
    int old_response = set_response(NLRSP_QUIET);
    init(RFD_port, O_RDWR | O_NONBLOCK);
    set_response(old_response);
    if (fd < 0) {
      if (!connect_waiting) {
        connect_waiting = true;
        msg(MSG_ERROR, "%s: Unable to open device %s: %s (%d)",
          iname, RFD_port, strerror(errno), errno);
      }
      queue_retry();
    } else {
      msg(MSG, "%s: Successfully opened %s", iname, RFD_port);
      setup(RFD_baud_rate, 8, 'n', 1, 0, 0);
      hwflow_enable(hwflow);
      flush_input();
      update_tc_vmin(serio::min_pkt_size,1);
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

void RFD_interface::queue_retry() {
  flags &= ~(Fl_Read | Fl_Write);
  flags |= Fl_Timeout;
  TO.Set(5, 0);
}

bool RFD_interface::protocol_input() {
 bool have_hdr;
  serio_pkt_type type;
  uint16_t length;
  uint8_t *payload;
  
  /* Unlike tm_ip_import, we are receiving serial data, so we won't
   * discard partial packets.
   */
  while (cp < nc) {
    bool rv = not_serio_pkt(have_hdr, type, length, payload);
    if (have_hdr &&
        ((type != pkt_type_TM) || (length != tm_info.tm.nbminf-2))) {
      report_err("%s: Invalid packet type '%c' or length %d (%d)",
        iname, type, length, tm_info.tm.nbminf-2);
      ++cp;
      continue;
    }
    if (rv) {
      consume(cp);
      return false;
    } else {
      serio->forward_packet((const char *)&buf[cp],
        serio::pkt_hdr_size+length);
      cp += serio::pkt_hdr_size + length;
    }
  }
  report_ok(cp);
  return false;
}

bool RFD_interface::protocol_timeout() {
  connect();
  return false;
}

const char *RFD_interface::ascii_escape() {
  return "<redacted>";
}

bool RFD_interface::protocol_except() {
  msg(MSG_ERROR, "%s: protocol_except()", iname);
  close();
  return process_eof();
}

bool RFD_interface::read_error(int my_errno) {
  msg(MSG_ERROR, "%s: read error %d: %s", iname,
    my_errno, strerror(my_errno));
  return false;
}

bool RFD_interface::process_eof() {
  msg(MSG_ERROR, "%s: fh closed unexpectedly", iname);
  queue_retry();
  return false;
}

serio_if::serio_if() :
    Client("serio", "tm_gen", "tm_gen", "serin", 10),
    packets_forwarded(0)
{
  set_obufsize(4096);
  connect();
}

bool serio_if::forward_packet(const char *pkt, int length) {
  if (is_negotiated() && obuf_empty()) {
    ++packets_forwarded;
    // if (nl_debug_level < -1 && !(packets_forwarded%100))
      // msg(MSG_DEBUG, "%s: packets_forwarded: %d", iname, packets_forwarded);
    return iwrite(pkt, length);
  } else {
    msg(MSG_DEBUG, "%s: Packet dropped", iname);
  }
  return true;
}

RFD_cmd::RFD_cmd(RFD_interface *RFD) :
    Cmd_reader("cmd", 256, "cmd_tx"),
    RFD(RFD)
{
  connect();
}

bool RFD_cmd::app_input() {
  // msg(MSG, "Received command '%s'", buf);
  if (strcmp((char*)buf, "Q\n") == 0) {
    report_ok(nc);
  } else if (obuf_empty()) {
    if (dropping_tx_cmds) {
      msg(MSG_DEBUG, "%s: Tx resumed after dropping %d cmds",
        iname, n_tx_cmds_dropped);
      dropping_tx_cmds = false;
      total_tx_cmds_dropped += n_tx_cmds_dropped;
      dropping_tx_cmds = false;
      n_tx_cmds_dropped = 0;
    }
    // We have allocated an obuf, so we can use auto vars for
    // io and hdr
    struct iovec io[2];
    serio_pkt_hdr hdr;
    hdr.LRC = 0;
    hdr.type = pkt_type_CMD;
    hdr.length = nc;
    io[0].iov_len = sizeof(serio_pkt_hdr);
    io[0].iov_base = &hdr;
    io[1].iov_len = nc;
    io[1].iov_base = buf;
    // Calculate the CRC of io[1]
    { unsigned CRC = crc16modbus_word(0,0,0);
      CRC = crc16modbus_word(CRC, io[1].iov_base, io[1].iov_len);
      hdr.CRC = CRC;
      uint8_t *hdrp = (uint8_t *)io[0].iov_base;
      for (uint32_t i = 1; i < io[0].iov_len; ++i) {
        hdr.LRC += hdrp[i];
      }
      hdr.LRC = -hdr.LRC;
    }
    RFD->tx_cmd(io, 2); // Errors are handled in callbacks
    report_ok(nc);
  } else {
    if (!dropping_tx_cmds) {
      msg(MSG_DEBUG, "%s: dropping command", iname);
      dropping_tx_cmds = true;
    }
    ++n_tx_cmds_dropped;
  }
  return false;
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;
  serio_if *serio = new serio_if();
  ELoop.add_child(serio);
  RFD_interface *RFD = new RFD_interface("radio", serio);
  ELoop.add_child(RFD);
  RFD_cmd *cmd = new RFD_cmd(RFD);
  ELoop.add_child(cmd);
  ELoop.event_loop();
  ELoop.delete_children();
  ELoop.clear_delete_queue(true);
  msg(MSG, "Terminating");
  return 0;
}

