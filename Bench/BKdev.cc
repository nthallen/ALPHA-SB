/** @file BKdev.cc */
#include <fcntl.h>
#include "dasio/msg.h"
#include "BKd_int.h"
#include "BKd.h" 

using namespace DAS_IO;

BK_device::BK_device() : Serial("BKdev", 80, BKd_port, O_RDWR) {
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
          if (TO.Expired()) {
            report_err("%s: CB_GETS timeout", iname);
          } else {
            return false; // wait for more input
          }
        }
      } else {
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
          if (TO.Expired()) {
            report_err("%s: CB_GETD timeout", iname);
          } else {
            return false; // wait for more input
          }
        }
      } else {
        BKd.V_disp = i1;
        BKd.I_disp = i2;
        BKd.Status = i3 ? 1 : 0; // clearing the stale bit
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

void BK_device::enqueue_polls() {
  RQ.enqueue_poll(0, 0, "GETS\r");
  RQ.enqueue_poll(0, 1, "GETD\r");
  process_requests();
}

bool BK_device::process_requests() {
  while (!RQ.pending) {
    RQ.pending = RQ.next_request();
    if (RQ.pending) {
      bool rv = iwrite((const char *)RQ.pending->reqstr,
                        RQ.pending->req_sz);
      if (rv) TO.Clear();
      else TO.Set(0, 100);
      return rv;
    } else {
      TO.Clear();
      break;
    }
  }
  return false;
}
