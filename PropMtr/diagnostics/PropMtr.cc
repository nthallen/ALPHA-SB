/** @file PropMtr.cc */
#include "PropMtr_int.h"
#include "dasio/tm_data_sndr.h"
#include "dasio/loop.h"
#include "dasio/quit.h"
#include "dasio/appid.h"
#include "pmc.h"
#include "oui.h"
#include "nl.h"

PropMtr_t PropMtr;

using namespace DAS_IO;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;
  Client Cmd("Cmd", 40, "cmd", "PropMtr");
  TM_data_sndr TM("TM", "PropMtr", (const char *)&PropMtr, sizeof(PropMtr));
  Modbus::RTU MB("RTU", 80, "/dev/ser1");
  MB.add_device(new Modbus::PMC_dev("PMC1", 0x01, &(PropMtr.Ctrl[0])));
  MB.add_device(new Modbus::PMC_dev("PMC2", 0x02, &(PropMtr.Ctrl[1])));
  Cmd.connect();
  TM.connect();
  ELoop.add_child(&Cmd);
  ELoop.add_child(&TM);
  ELoop.add_child(&MB);
  nl_error(0, "%s %s Starting", DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  ELoop.event_loop();
  nl_error(0, "%s Terminating", DAS_IO::AppID.name);
  return 0;
}
