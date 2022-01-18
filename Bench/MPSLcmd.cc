/** @file MPSLcmd.cc */
#include "MPSLd_int.h"
#include "MPSLd.h"

using namespace DAS_IO;

MPSLdCmd::MPSLdCmd(MPSL_device *MPSL_dev) : Cmd_reader("MPSLd", 20, "MPSLd") {
  this->MPSL_dev = MPSL_dev;
}

bool MPSLdCmd::app_input() {
  float farg;
  uint16_t arg;
  while (cp < nc) {
    switch (buf[cp]) {
      case 'V':
        if (not_str("V:") ||
            not_float(farg) ||
            not_str("\n")) {
          report_err("%s: invalid V command", iname);
          consume(nc);
        } else {
          if (farg < 0) farg = 0;
          MPSL_dev->RQ.enqueue_cmd(0, MPSL_dev->CB_CMD, "VOLT %.1f\r\n", farg);
          consume(cp);
        }
        break;
      case 'I':
        if (not_str("I:") ||
            not_float(farg) ||
            not_str("\n")) {
          report_err("%s: invalid I command", iname);
          consume(nc);
        } else {
          if (farg < 0) farg = 0;
          MPSL_dev->RQ.enqueue_cmd(0, MPSL_dev->CB_CMD, "CURR %.1f\r\n", farg);
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
          MPSL_dev->RQ.enqueue_cmd(0, MPSL_dev->CB_CMD, "OUTP:%s\r\n",
                                  arg ? "START" : "STOP");
          consume(cp);
        }
        break;
      case 'C':
        if (not_str("C:") ||
            not_uint16(arg) ||
            not_str("\n")) {
          report_err("%s: invalid C command", iname);
          consume(nc);
        } else {
          MPSL_dev->RQ.enqueue_cmd(0, MPSL_dev->CB_CMD,
            "CONF:SETPT %u\r\n", arg);
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
