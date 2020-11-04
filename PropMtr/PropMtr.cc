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
PropMtr_fast_t PropMtr_fast;
const char *PropMtr_port = "/dev/ttyUSB0";

using namespace DAS_IO;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;
  
  // Setup Telemetry
/*
  TM_data_sndr *TM =
    new TM_data_sndr("TM", 0, "PropMtr", (void *)&PropMtr, sizeof(PropMtr));
*/
  TM_data_sndr *TMf =
    new TM_data_sndr("TMf", 0, "PropMtr_fast", (void *)&PropMtr_fast,
      sizeof(PropMtr_fast));
  TMf->set_gflag_no(1);
  
  // Setup Modbus
/*   Modbus::RTU *MB = new Modbus::PMC("RTU", 80, PropMtr_port);
  MB->setup(115200, 8, 'n', 1, 5, 1);
  MB->flush_input();
  
  // Setup Modbus Devices
  MB->add_device(new Modbus::PMC_dev("PMC1", 63,
        &(PropMtr.Ctrl[0]), &(PropMtr_fast.Ctrl[0])));
  // MB->add_device(new Modbus::PMC_dev("PMC2", 0x02,
  //    &(PropMtr.Ctrl[1]), &(PropMtr_fast.Ctrl[1]));

  PropMtrCmd *Cmd = new PropMtrCmd(MB);
  Cmd->connect();
  ELoop.add_child(Cmd);
 */
 /*
  TM->connect();
  ELoop.add_child(TM);
 */
  TMf->connect();
  ELoop.add_child(TMf);

  // ELoop.add_child(MB);
  msg(0, "%s %s Starting", DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  ELoop.event_loop();
  ELoop.delete_children();
  msg(0, "%s Terminating", DAS_IO::AppID.name);
  return 0;
}
