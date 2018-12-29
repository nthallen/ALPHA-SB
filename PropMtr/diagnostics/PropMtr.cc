/** @file PropMtr.cc */
#include "PropMtr_int.h"
#include "dasio/tm_client.h"
#include "dasio/loop.h"
#include "oui.h"

PropMtr_t PropMtr;

using namespace DAS_IO;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;
  Client Cmd("Cmd", 40, "cmd", "PropMtr");
  TM_client TM("TM", "PropMtr", (const char *)&PropMtr, sizeof(PropMtr));
  // Modbus::RTU("RTU", 80, "/dev/ser1");
  Cmd.connect();
  TM.connect();
  ELoop.add_child(&Cmd);
  ELoop.add_child(&TM);
  ELoop.event_loop();
  return 0;
}
