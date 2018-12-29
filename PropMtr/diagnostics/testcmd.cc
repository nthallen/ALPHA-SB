/** @file testcmd.cc */
#include "dasio/server.h"
#include "dasio/loop.h"
#include "dasio/appid.h"

namespace DAS_IO {

AppID_t AppID("MyServer", "A Powerful Server", "V1.0");



int main(int argc, char **argv) {
  SubServices Subs;
  Loop ELoop;
  Subs.add_subservice(new SubService("DG/cmd", cmd_svc, 0));
  Subs.add_subservice(new SubService("DG/data/MtrCtrl", data_svc, 0));
  DAS_IO::Server S1(iname, bufsz, service, Socket::Socket_Unix, &Subs);
  DAS_IO::Server S2(iname, bufsz, service, Socket::Socket_TCP, &Subs);
  ELoop->add_child(&S1);
  ELoop->add_child(&S2);
  ELoop->event_loop();
  return 0;
}

}
