/** @file MPSLdev.cc */
#include <fcntl.h>
#include <string.h>
#include "dasio/msg.h"
#include "MPSLd_int.h"
#include "MPSLd.h" 

using namespace DAS_IO;

MPSL_device::reqdef_t MPSL_device::reqdef = {
    0,   CID_NONE, false, // CB_NONE
  100,    CID_NR2,  true, // CB_VOLT <NR2>
  100,    CID_NR2,  true, // CB_CURR <NR2>
  100,    CID_NR2,  true, // CB_MVOLT <NR2>
  100,    CID_NR2,  true, // CB_MCURR <NR2>
  100,    CID_NR1,  true, // CB_OUTP  <NR1>
  100,    CID_NR1,  true, // CB_SETPT <NR1>
  100,    CID_NR1,  true, // CB_STATUS <NR1>
  100, CID_SYSERR,  true, // CB_SYSERR "Special!"
    0,   CID_NONE, false  // CB_CMD
};

MPSL_device::MPSL_device()
    : Socket("MPSLdev", "MPSL", "MPSL", 80) {
  enqueue_polls();
}

bool MPSL_device::protocol_input() {
  uint16_t VNR1;
  float VNR2;
  CB_ID cbid = (CB_ID) (RQ.pending ? RQ.pending->get_callback_id(CB_MAX) : CB_NONE);
  switch (reqdef[cbid].conv) {
    case CID_NONE:
      report_err("%s: Unexpected input", iname);
      consume(nc);
      return false;
    case CID_NR1:
      if (not_uint16(VNR1) ||
          not_str("\n")) {
        if (cp < nc) {
          report_err("%s: CB_ID %d CID_NR1 response error", iname, cbid);
          consume(nc);
        } else {
          msg(MSG_DEBUG, "%s: CB_ID %d CID_NR1 incomplete, waiting",
                          iname, cbid);
          return false; // wait for more input
        }
      } else {
        msg(MSG_DEBUG, "%s: CB_ID %d CID_NR1 complete", iname, cbid);
        switch (cbid) {
          case CB_OUTP:
            MPSLd.Status = VNR1 ?
              (MPSLd.Status | OUTP_MASK) :
              (MPSLd.Status & ~OUTP_MASK);
            break;
          case CB_SETPT:
            MPSLd.Status = VNR1 ?
              (MPSLd.Status | SETPT_MASK) :
              (MPSLd.Status & ~SETPT_MASK);
            break;
          case CB_STATUS:
            MPSLd.Status =
              (MPSLd.Status & ~STATUS_MASK) |
              (VNR1&STATUS_MASK);
            break;
          default:
            msg(MSG_EXIT_ABNORM, "%s: Invalid CB_ID %u for CONV_NR1",
              iname, cbid);
            break;
        }
        report_ok(cp);
      }
      break;
    case CID_NR2:
      if (not_float(VNR2) ||
          not_str("\n")) {
        if (cp < nc) {
          report_err("%s: CB_ID %d CID_NR2 response error", iname, cbid);
          consume(nc);
        } else {
          msg(MSG_DEBUG, "%s: CB_ID %d CID_NR2 incomplete, waiting",
                          iname, cbid);
          return false; // wait for more input
        }
      } else {
        msg(MSG_DEBUG, "%s: CB_ID %d CID_NR1 complete", iname, cbid);
        switch (cbid) {
          case CB_VOLT:  MPSLd.V_set = VNR2; break;
          case CB_CURR:  MPSLd.I_set = VNR2; break;
          case CB_MVOLT: MPSLd.V_disp = VNR2; break;
          case CB_MCURR: MPSLd.V_disp = VNR2; break;
          default:
            msg(MSG_EXIT_ABNORM, "%s: Invalid CB_ID %u for CONV_NR2",
              iname, cbid);
            break;
        }
        report_ok(cp);
      }
      break;
    default:
      msg(MSG_EXIT_ABNORM, "%s: Invalid CONV_ID %u (CB_ID %u)",
          iname, reqdef[cbid].conv, cbid);
      report_ok(nc);
      break;
  }
  RQ.dispose_pending();
  return process_requests();
}

bool MPSL_device::protocol_timeout() {
  int cbid = RQ.pending->get_callback_id(CB_MAX);
  if (reqdef[cbid].has_response) {
    report_err("%s: Timeout", iname);
  }
  TO.Clear();
  RQ.dispose_pending();
  return process_requests();
}

bool MPSL_device::protocol_gflag(int flag) {
  MPSLd.Status |= 2;
  RQ.requeue_polls();
  return process_requests();
}

void MPSL_device::enqueue_polls() {
  RQ.enqueue_poll(0, CB_VOLT, "VOLT?\n");
  RQ.enqueue_poll(0, CB_CURR, "CURR?\n");
  RQ.enqueue_poll(0, CB_MVOLT, "MEAS:VOLT?\n");
  RQ.enqueue_poll(0, CB_MCURR, "MEAS:CURR?\n");
  RQ.enqueue_poll(0, CB_OUTP, "OUTP?\n");
  RQ.enqueue_poll(0, CB_SETPT, "CONF:SETPT?\n");
  RQ.enqueue_poll(0, CB_STATUS, "STAT:OPER:COND?\n");
  RQ.enqueue_poll(0, CB_SYSERR, "SYST:ERR?\n");
}

bool MPSL_device::process_requests() {
  while (!RQ.pending) {
    RQ.pending = RQ.next_request();
    if (RQ.pending) {
      bool rv = iwrite((const char *)RQ.pending->reqstr,
                        RQ.pending->req_sz);
      msg(MSG_DEBUG, "%s: process_requests() issued '%.4s' rv=%d",
          iname, RQ.pending->reqstr, rv);
      int cbid = RQ.pending->get_callback_id(CB_MAX);
      int msec = reqdef[cbid].timeout_msec;
      if (msec) TO.Set(0, msec);
      else {
        TO.Clear();
        if (!reqdef[cbid].has_response) {
          RQ.dispose_pending();
          continue;
        }
      }
      return rv;
    } else {
      msg(MSG_DEBUG, "%s: process_requests() queue empty", iname);
      TO.Clear();
      break;
    }
  }
  return false;
}

bool MPSL_device::connected() {
  flags |= Fl_Timeout | gflag(0);
  return process_requests();
}
