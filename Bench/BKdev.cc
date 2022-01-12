/** @file BKdev.cc */
#include <fcntl.h>
#include "dasio/msg.h"
#include "BKd_int.h"
#include "BKd.h" 

using namespace DAS_IO;

BK_device::BK_device() : Serial("BKdev", 80, BKd_port, O_RDWR) {
  flags |= Fl_Timeout | gflag(0);
}

bool BK_device::protocol_input() {
  int i1, i2, i3;
  CB_ID cbid = (CB_ID) (RQ.pending ? RQ.pending->callback_id : CB_NONE);
  switch (cbid) {
    case CB_NONE:
      report_err("%s: Unexpected input", iname);
      consume(nc);
      return false;
    case CB_GETS:
      if (not_ndigits(3, i1) ||
          not_ndigits(3, i2) ||
          not_str("\rOK\r")) {
        if (cp < nc) {
          report_err("%s: CB_GETS response error", iname);
          consume(nc);
        } else {
          msg(MSG_DEBUG, "%s: CB_GETS incomplete, waiting", iname);
          return false; // wait for more input
        }
      } else {
        msg(MSG_DEBUG, "%s: CB_GETS complete", iname);
        BKd.V_set = i1;
        BKd.I_set = i2;
        report_ok(cp);
      }
      break;
    case CB_GETD:
      if (not_ndigits(4, i1) ||
          not_ndigits(4, i2) ||
          not_ndigits(1, i3) ||
          not_str("\rOK\r")) {
        if (cp < nc) {
          report_err("%s: CB_GETD response error", iname);
          consume(nc);
        } else {
          msg(MSG_DEBUG, "%s: CB_GETD incomplete, waiting", iname);
          return false; // wait for more input
        }
      } else {
        msg(MSG_DEBUG, "%s: CB_GETD complete: i3=%d", iname, i3);
        BKd.V_disp = i1;
        BKd.I_disp = i2;
        BKd.Status = i3 ? 1 : 0; // clearing the stale bit
        report_ok(cp);
      }
      break;
    case CB_CMD:
      if (not_str("OK\r")) {
        if (cp < nc) {
          report_err("%s: Command response error", iname);
          consume(nc);
        } else {
          msg(MSG_DEBUG, "%s: Command response incomplete, waiting", iname);
          return false; // wait for more input
        }
      } else {
        report_ok(cp);
      }
      break;
    default:
      msg(MSG_ERROR, "%s: Invalid callback ID %d", iname, cbid);
      report_ok(nc);
      break;
  }
  RQ.dispose_pending();
  return process_requests();
}

bool BK_device::protocol_timeout() {
  report_err("%s: Timeout", iname);
  TO.Clear();
  RQ.dispose_pending();
  return process_requests();
}

bool BK_device::protocol_gflag(int flag) {
  BKd.Status |= 2;
  RQ.requeue_polls();
  return process_requests();
}

void BK_device::enqueue_polls() {
  RQ.enqueue_poll(0, CB_GETS, "GETS\r");
  RQ.enqueue_poll(0, CB_GETD, "GETD\r");
  process_requests();
}

bool BK_device::process_requests() {
  while (!RQ.pending) {
    RQ.pending = RQ.next_request();
    if (RQ.pending) {
      bool rv = iwrite((const char *)RQ.pending->reqstr,
                        RQ.pending->req_sz);
      msg(MSG_DEBUG, "%s: process_requests() issued '%.4s' rv=%d",
          iname, RQ.pending->reqstr, rv);
      if (rv) TO.Clear();
      else TO.Set(0, 100);
      return rv;
    } else {
      msg(MSG_DEBUG, "%s: process_requests() queue empty", iname);
      TO.Clear();
      break;
    }
  }
  return false;
}
