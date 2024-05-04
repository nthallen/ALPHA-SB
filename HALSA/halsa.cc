#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <errno.h>
#include <unistd.h>

#include "dasio/msg.h"
#include "dasio/quit.h"
#include "dasio/tm_data_sndr.h"
#include "dasio/appid.h"
#include "nl.h"
#include "nl_assert.h"
#include "oui.h"
#include "halsa_int.h"

using namespace DAS_IO;

HALSA_t HALSA;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  DAS_IO::Loop ELoop;
  
  UserPkts_UDP *Pkts = new UserPkts_UDP(1409); // constructor generated
  ELoop.add_child(Pkts);
  
  Quit *Q = new Quit();
  Q->connect();
  ELoop.add_child(Q);
  
  TM_data_sndr *TM =
    new TM_data_sndr("HALSA", 0, "HALSA", &HALSA, sizeof(HALSA));
  TM->connect();
  ELoop.add_child(TM);

  AppID.report_startup();
  ELoop.event_loop();
  AppID.report_shutdown();
  ELoop.delete_children();
  ELoop.clear_delete_queue(true);
  return 0;
}

UserPkts_UDP::UserPkts_UDP(int udp_port)
    : DAS_IO::Interface("UDP", 512),
      udp_port(udp_port) {
  Bind(udp_port);
  setenv("TZ", "UTC0", 1); // Force UTC for mktime()
  flags |= gflag(0);
}

bool UserPkts_UDP::protocol_input() {
  // double Time;
  double Time;
  double elapsed_sec;
  float deflection;
  float velocity;
  float temperature;
  float std_deflection;
  uint8_t n_detected;
  // int year, month, day, hour, minute, second;
  // struct tm buft;
  // le_time_t ltime;

  cp = 0;
  if (not_str("HALSA,") || not_spaces() ||
      not_ISO8601(Time) || not_str(",", 1) ||
      not_ndouble(elapsed_sec, 0) || not_str(",", 1) ||
      not_nfloat(&deflection, 9999.) || not_str(",", 1) ||
      not_nfloat(&velocity, 9999.)  || not_str(",", 1) ||
      not_nfloat(&temperature, 9999.) ||
        not_str(",", 1) || not_spaces() ||
      not_uint8(n_detected) || not_str(",", 1) ||
      not_nfloat(&std_deflection, 9999.) ||
      not_str("\n", 1)) {
    if (cp >= nc) {
      report_err("%s: Incomplete record", iname);
    }
    consume(nc);
  } else {
    HALSA.Time = Time;
    HALSA.elapsed_msecs = elapsed_sec >= 0 ?
      floor(elapsed_sec*1000) : 0;
    HALSA.deflection = deflection;
    HALSA.velocity = velocity;
    HALSA.temperature = temperature;
    HALSA.Stale = 0;
    report_ok(nc);
  }
  return false;
}

bool UserPkts_UDP::tm_sync() {
  if (HALSA.Stale < 255) ++HALSA.Stale;
  return false;
}

bool UserPkts_UDP::process_eof() {
  msg(0, "%s: process_eof(): Re-binding UDP port %d",
    iname, udp_port);
  Bind(udp_port);
  return false;
}

void UserPkts_UDP::Bind(int port) {
  char service[10];
  struct addrinfo hints,*results, *p;
  int err, ioflags;

  if (port == 0)
    msg( 3, "Invalid port in UserPkts_UDP: 0" );
  snprintf(service, 10, "%d", port);

  memset(&hints, 0, sizeof(hints));	
  hints.ai_family = AF_UNSPEC;		// don't care IPv4 of v6
  hints.ai_socktype = SOCK_DGRAM;
  hints.ai_flags = AI_PASSIVE;
    
  err = getaddrinfo(NULL, 
                    service,
                    &hints,
                    &results);
  if (err)
    msg( 3, "UserPkts_UDP::Bind: getaddrinfo error: %s",
          gai_strerror(err) );
  for(p=results; p!= NULL; p=p->ai_next) {
    fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
    if (fd < 0)
      msg( 2, "IWG1_UPD::Bind: socket error: %s", strerror(errno) );
    else if ( bind(fd, p->ai_addr, p->ai_addrlen) < 0 )
      msg( 2, "UserPkts_UDP::Bind: bind error: %s", strerror(errno) );
    else break;
  }
  if (fd < 0)
    msg(3, "Unable to bind UDP socket");
    
  ioflags = fcntl(fd, F_GETFL, 0);
  if (ioflags != -1)
    ioflags = fcntl(fd, F_SETFL, ioflags | O_NONBLOCK);
  if (ioflags == -1)
    msg( 3, "Error setting O_NONBLOCK on UDP socket: %s",
      strerror(errno));
  flags |= DAS_IO::Interface::Fl_Read;
}
