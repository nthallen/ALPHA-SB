/** @file PMkbd.cc
 * @brief A simple command client to test the command server
 */
#include <unistd.h>
#include "dasio/cmd_writer.h"
#include "dasio/appid.h"
#include "oui.h"
#include "nl.h"

DAS_IO::AppID_t DAS_IO::AppID("PMkbd", "Command writer test", "V1.0");

void oui_init_options(int argc, char **argv) {}

const char *opt_string = "";

int main(int argc, char **argv) {
  nl_error(0, "%s %s %s Starting",
    DAS_IO::AppID.name, DAS_IO::AppID.fullname, DAS_IO::AppID.rev);
  if (cic_init()) {
    nl_error(3, "Error negotiating connection to command server");
  }
  nl_error(0, "Connected to command server");
  sleep(4);
  nl_error(0, "Sending Log command");
  ci_sendcmd(DAS_IO::Cmd_Send, "Log Testing a log command\n");
 //  sleep(4);
 //  nl_error(0, "Sending unlogged Log command");
 //  ci_sendcmd(DAS_IO::Cmd_Send_Quiet, "Log Testing a log command\n");
 //  sleep(4);
 //  nl_error(0, "Sending Quit syntax error");
 //  ci_sendcmd(DAS_IO::Cmd_Send, "Quite\n");
  sleep(4);
  nl_error(0, "Sending Quit command");
  ci_sendcmd(DAS_IO::Cmd_Send, "Quit\n");
  nl_error(0, "Terminating");
  return 0;
}
