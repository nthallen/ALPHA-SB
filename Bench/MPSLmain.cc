/** @file MPSLmain.cc
 * MPSLd Main Module
 * Magna-Power SL Series Bench Power Supply Driver Main Module
 */
#include "dasio/loop.h"
#include "dasio/tm_data_sndr.h"
#include "dasio/appid.h"
#include "dasio/msg.h"
#include "MPSLd_int.h"
#include "MPSLd.h"
#include "oui.h"

using namespace DAS_IO;

MPSLd_t MPSLd;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;

  // Set up TM interface
  TM_data_sndr *TM =
    new TM_data_sndr("TM", 0, "MPSLd", (void *)&MPSLd, sizeof(MPSLd));
  TM->connect();
  ELoop.add_child(TM);

  // Set up device interface
  MPSL_device *MPSL_dev = new MPSL_device();
  ELoop.add_child(MPSL_dev);
  MPSL_dev->connect();

  // Set up command interface
  MPSLdCmd *cmd = new MPSLdCmd(MPSL_dev);
  ELoop.add_child(cmd);
  cmd->connect();
  
  msg(0, "%s %s Starting", DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  ELoop.event_loop();
  ELoop.delete_children();
  msg(0, "%s Terminating", DAS_IO::AppID.name);
  return 0;
}
