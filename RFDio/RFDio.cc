#include <cstring>
#include "RFDio_int.h"
#include "dasio/loop.h"
#include "crc16modbus.h"
#include "oui.h"
#include "nl.h"

using namespace DAS_IO;

const char *RFD_interface::RFD_port;
int RFD_interface::RFD_baud_rate = 57600;

RFD_interface::RFD_interface(const char *name, serio_if *serio) :
    Serial(name, ibufsize),
    write_blocked(false),
    connect_waiting(false),
    recd_pkts_dropped(0),
    serio(serio)
{
  flags = Fl_Except;
  connect();
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
      hwflow_enable(true);
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

bool RFD_interface::not_serio_pkt_hdr() {
  uint8_t lrc_sum = 0;
  int cp0 = cp;
  if (nc-cp < serio::pkt_hdr_size) return true;
  for (int i = 0; i < serio::pkt_hdr_size; ++i) {
    lrc_sum += buf[cp+i];
  }
  if (lrc_sum == 0) return false;
  while (nc-cp > serio::pkt_hdr_size) {
    lrc_sum -= buf[cp++];
    lrc_sum += buf[cp+serio::pkt_hdr_size-1];
    if (lrc_sum == 0) {
      msg(MSG_ERROR, "%s: Skipping %d bytes", iname, cp-cp0);
      return false;
    }
  }
  ++cp;
  msg(MSG_ERROR, "%s: Skipping %d bytes", iname, cp-cp0);
  return true;
}

bool RFD_interface::protocol_input() {
  while (nc-cp >= serio::pkt_hdr_size) {
    if (not_serio_pkt_hdr()) {
      consume(cp);
      return false;
    }
    serio_pkt_hdr *hdr = (serio_pkt_hdr*)&buf[cp];
    if (hdr->length > serio::max_pkt_payload) {
      msg(MSG_ERROR, "%s: Invalid pkt length: %d", iname, hdr->length);
      ++cp;
      continue;
    }
    switch (hdr->type) {
      case pkt_type_TM:
        break;
      case pkt_type_PNG_Start:
      case pkt_type_PNG_Cont:
      case pkt_type_CMD:
      default:
        msg(MSG_ERROR, isgraph(hdr->type) ?
          "%s: Invalid packet type: '%c'" :
          "%s: Invalid packet type: 0x%02X",
            iname, hdr->type);
        ++cp;
        continue;
    }
    if (nc-cp < (unsigned)serio::pkt_hdr_size+hdr->length) {
      // Full packet not present
      if (cp+serio::pkt_hdr_size+hdr->length > (unsigned)bufsize) {
        consume(cp);
      }
      break;
    }
    uint16_t CRC = crc16modbus_word(0,0,0);
    CRC = crc16modbus_word(CRC,
              &buf[cp+serio::pkt_hdr_size], hdr->length);
    if (CRC != hdr->CRC) {
      msg(MSG_ERROR, "%s: CRC error: hdr: 0x%04X calc: 0x%04X",
        iname, hdr->CRC, CRC);
      ++cp;
      continue;
    }
    switch (hdr->type) {
      case pkt_type_TM:
        serio->forward_packet((const char *)&buf[cp],
          serio::pkt_hdr_size+hdr->length);
        cp += serio::pkt_hdr_size + hdr->length;
        report_ok(nc-cp < serio::max_pkt_payload + serio::pkt_hdr_size
                  ? cp : 0);
        continue;
      case pkt_type_PNG_Start:
      case pkt_type_PNG_Cont:
      case pkt_type_CMD:
      default:
        msg(MSG_ERROR, "%s: Unexpected type on second check", iname);
        ++cp;
        continue;
    }
  }
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
    Client("serio", 10, 0, "tm_gen", "serio")
{
  connect();
}

bool serio_if::forward_packet(const char *pkt, int length) {
  if (is_negotiated() && obuf_empty()) {
    return iwrite(pkt, length);
  }
  return true;
}

RFD_cmd::RFD_cmd(RFD_interface *RFD) :
    Cmd_reader("cmd", 256, "RFDio"),
    RFD(RFD)
{
  connect();
}

bool RFD_cmd::app_input() {
  msg(MSG, "Received command '%s'", buf);
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

