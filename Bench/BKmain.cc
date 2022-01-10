/** @file BKmain.cc
 * BKd Main Module
 * BK Precision 1687B Bench Power Supply Driver Main Module
 */
#include "dasio/loop.h"
#include "dasio/tm_data_sndr.h"
#include "dasio/appid.h"
#include "dasio/msg.h"
#include "BKd_int.h"
#include "BKd.h"
#include "oui.h"

using namespace DAS_IO;

BKd_t BKd;
const char *BKd_port;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  Loop ELoop;

  // Set up TM interface
  TM_data_sndr *TM =
    new TM_data_sndr("TM", 0, "BKd", (void *)&BKd, sizeof(BKd));
  TM->connect();
  ELoop.add_child(TM);

  // Set up device interface
  BK_device *BK_dev = new BK_device();
  BK_dev->setup(9600,8,'n',1,-1,'\r');
  BK_dev->enqueue_polls();
  ELoop.add_child(BK_dev);

  // Set up command interface
  BKdCmd *cmd = new BKdCmd(BK_dev);
  ELoop.add_child(cmd);
  cmd->connect();
  
  msg(0, "%s %s Starting", DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  ELoop.event_loop();
  ELoop.delete_children();
  msg(0, "%s Terminating", DAS_IO::AppID.name);
  return 0;
}
