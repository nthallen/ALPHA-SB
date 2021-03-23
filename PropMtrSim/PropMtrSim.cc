/** @file PropMtr.cc */
#include "PropMtrSim_int.h"
#include "dasio/tm_data_sndr.h"
#include "dasio/loop.h"
#include "dasio/quit.h"
#include "dasio/appid.h"
#include "pmc.h"
#include "oui.h"
#include "nl.h"

PropMtr_t PropMtr;
PropMtr_fast_t PropMtr_fast;
const char *PropMtr_port = "/dev/ttyUSB0";
int32_t SimRate = 10; // Hz

using namespace DAS_IO;

PropMtrTMf::PropMtrTMf(const char *iname, const char *datum,
              const void *data, uint16_t size)
    : TM_data_sndr(iname, 0, datum, data, size) {}

bool PropMtrTMf::app_input() {
  report_ok(nc);
  Send();
  int32_t max_accel = 75 * 65536 / (75 * SimRate);
  for (int DevID = 0; DevID < 2; ++DevID) {
    int32_t dDemand = PropMtr.Ctrl[DevID].SetPoint -
      PropMtr.Ctrl[DevID].VelocityDemand;
    if (dDemand > max_accel) {
      PropMtr.Ctrl[DevID].VelocityDemand += max_accel;
    } else if (dDemand < -max_accel) {
      PropMtr.Ctrl[DevID].VelocityDemand -= max_accel;
    } else {
      PropMtr.Ctrl[DevID].VelocityDemand += dDemand;
    }
    PropMtr_fast.Ctrl[DevID].VelocityMeasured =
      PropMtr.Ctrl[DevID].VelocityDemand;
  }
  return false;
}

PropMtrCmd::PropMtrCmd()
    : DAS_IO::Cmd_reader("Cmd", 40, "PropMtr") {}

bool PropMtrCmd::app_input() {
  uint16_t devID, func, addr, count, data[2];
  if (cp < nc) {
    int arg_count;
    if (buf[cp] == 'Q') return true;
    if (not_str("W") ||
        not_hex(devID) || not_str(":") ||
        not_hex(func) || not_str(":") ||
        not_hex(addr) || not_str(":") ||
        not_hex(count)) {
      if (cp<nc) {
        clear_to_newline();
      }
      return false;
    }
    arg_count = (func == 15) ? (count+7)/8 : count;
    if (arg_count < 1 || arg_count > 2) {
      report_err("%s: Unsupported count %d for function %d", iname, count, func);
      clear_to_newline();
      return false;
    }
    for (int i = 0; i < arg_count; ++i) {
      if (not_str(":") || not_hex(data[i])) {
        if (cp < nc) clear_to_newline();
        return false;
      }
    }
    if (not_str("\n")) { // The final newline
      if (cp < nc) clear_to_newline();
      return false;
    }
    if (func == 15 && arg_count == 2) {
      data[0] = (data[0] & 0xFF) | ((data[1] << 8) & 0xFF00);
    }
    if (devID > 0x01) {
      report_err("%s: Invalid device ID %d", iname, devID);
      clear_to_newline();
      return false;
    }
    
    if (func == 16 && addr == 321) {
      PropMtr.Ctrl[devID].SetPoint =
        data[0] + ((uint32_t)data[1] << 16);
    }
    report_ok(cp);
  }
  return false;
}

void PropMtrCmd::clear_to_newline() {
  while (cp < nc) {
    if (buf[cp] == '\n') {
      ++cp;
      break;
    } else {
      ++cp;
    }
  }
  consume(cp);
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;
  
  // Setup Telemetry

  TM_data_sndr *TM =
    new TM_data_sndr("TM", 0, "PropMtr", (void *)&PropMtr, sizeof(PropMtr));

  PropMtrTMf *TMf =
    new PropMtrTMf("TMf", "PropMtr_fast", (void *)&PropMtr_fast,
      sizeof(PropMtr_fast));

  PropMtrCmd *Cmd = new PropMtrCmd();
  Cmd->connect();
  ELoop.add_child(Cmd);

  TM->connect();
  ELoop.add_child(TM);

  TMf->connect();
  ELoop.add_child(TMf);

  msg(0, "%s %s Starting", DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  ELoop.event_loop();
  ELoop.delete_children();
  ELoop.clear_delete_queue(true);
  msg(0, "%s Terminating", DAS_IO::AppID.name);
  return 0;
}
