/** @file BKcmd.cc */
#include "BKd_int.h"
#include "BKd.h"

using namespace DAS_IO;

BKdCmd::BKdCmd(BK_device *BK_dev) : Cmd_reader("BKd", 20, "BKd") {
  this->BK_dev = BK_dev;
}

bool BKdCmd::app_input() {
  uint16_t arg;
  while (cp < nc) {
    switch (buf[cp]) {
      case 'V':
        if (not_str("V:") ||
            not_uint16(arg) ||
            not_str("\n")) {
          report_err("%s: invalid V command", iname);
          consume(nc);
        } else {
          BK_dev->RQ.enqueue_cmd(0, BK_dev->CB_CMD, "VOLT%03u\r", arg);
          consume(cp);
        }
        break;
      case 'I':
        if (not_str("I:") ||
            not_uint16(arg) ||
            not_str("\n")) {
          report_err("%s: invalid I command", iname);
          consume(nc);
        } else {
          BK_dev->RQ.enqueue_cmd(0, BK_dev->CB_CMD, "CURR%03u\r", arg);
          consume(cp);
        }
        break;
      case 'S':
        if (not_str("S:") ||
            not_uint16(arg) ||
            not_str("\n")) {
          report_err("%s: invalid S command", iname);
          consume(nc);
        } else {
          BK_dev->RQ.enqueue_cmd(0, BK_dev->CB_CMD, "SOUT%u\r",
                                  arg ? 1 : 0);
          consume(cp);
        }
        break;
      case 'Q':
        consume(nc);
        return true;
      default:
        report_err("%s: invalid command", iname);
        consume(nc);
    }
  }
  return false;
}
