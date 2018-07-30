#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <errno.h>
#include <time.h>
#include "MiniMPL.h"
#include "nortlib.h"

MMPL_UDP::MMPL_UDP(int port) {
  char service[10];
  struct addrinfo hints, *results, *p;
  int err, ioflags;

  if (port == 0)
    nl_error( 3, "Invalid port in Bind: 0" );
  snprintf(service, 10, "%d", port);
  this->port = port;

  memset(&hints, 0, sizeof(hints));	
  hints.ai_family = AF_UNSPEC;		// don't care IPv4 or v6
  hints.ai_socktype = SOCK_DGRAM;
  hints.ai_flags = AI_PASSIVE;

  err = getaddrinfo(NULL, 
                    service,
                    &hints,
                    &results);
  if (err)
    nl_error( 3, "Bind: getaddrinfo error: %s", gai_strerror(err) );
  for(p=results; p!= NULL; p=p->ai_next) {
    fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
    if (fd < 0)
      nl_error( 2, "MMPL_UPD::Bind: socket error: %s", strerror(errno) );
    else if ( bind(fd, p->ai_addr, p->ai_addrlen) < 0 )
      nl_error( 2, "MMPL_UPD::Bind: bind error: %s", strerror(errno) );
    else break;
  }
  if (fd < 0)
    nl_error(3, "Unable to bind UDP socket");
    
  // ioflags = fcntl(fd, F_GETFL, 0);
  // if (ioflags != -1)
    // ioflags = fcntl(fd, F_SETFL, ioflags | O_NONBLOCK);
  // if (ioflags == -1)
    // nl_error( 3, "Error setting O_NONBLOCK on UDP socket: %s",
      // strerror(errno));
}

MMPL_UDP::~MMPL_UDP() {}

void MMPL_UDP::collect() {
  for (;;) {
    int nr = read(fd, &ibuf, sizeof(ibuf));
    if (clock_gettime(CLOCK_REALTIME, &now) < 0)
      nl_error(3, "clock_gettime error %d: %s", errno, strerror(errno));
    if (nr < 0) {
      nl_error(2, "Error %d on read: %s", errno, strerror(errno));
      return;
    }
    if (nr < 10) {
      nl_error(2, "Received short packet of %d bytes", nr);
      continue;
    }
    if (ibuf.status.Sync[0] != 'M' || ibuf.status.Sync[1] != 'P') {
      nl_error(2, "Invalid Sync: 0x%02X 0x%02X", ibuf.status.Sync[0],
        ibuf.status.Sync[1]);
    }
    switch (ibuf.status.MsgType) {
      case Msg_MMPL_NRB:
        if (ibuf.NRB.Size < 16) {
          nl_error(2, "%s: NRB record < 16: %d", ibuf.NRB.Size);
          continue;
        }
        if (ibuf.NRB.Size != 16+4*ibuf.NRB.NBins) {
          nl_error(2, "%s: NRB size expected %d: recd %d",
            16+4*ibuf.NRB.NBins, ibuf.NRB.Size);
          continue;
        }
        nl_error(0, "%s: NRB T:%u NBins:%d W:%.0f D:%.0f",
          timefmt(), ibuf.NRB.Seconds, ibuf.NRB.NBins,
          ibuf.NRB.BinWidth, ibuf.NRB.BinDist);
        break;
      case Msg_MMPL_Status:
        if (ibuf.status.Size != 16)
          nl_error(2, "%s: Status record size incorrect: %d, expected 16",
            timefmt(), ibuf.status.Size);
        nl_error(0, "%s: Status Cmds:%d HW:%d En:%d Prof:%d", timefmt(),
          ibuf.status.CmdCount, ibuf.status.HWFound,
          ibuf.status.Enable, ibuf.status.ProfCount);
        break;
      case Msg_MMPL_Open:
      case Msg_MMPL_Start:
      case Msg_MMPL_Stop:
        nl_error(1, "Unexpected command packet type %d",
                      ibuf.status.MsgType);
        break;
    }
  }
}

const char *MMPL_UDP::timefmt() {
  unsigned short t2d = now.tv_sec % 86400;
  unsigned short msec = now.tv_nsec/1000000;
  snprintf(time_string, 10, "%5u.%03u", t2d, msec);
  return &time_string[0];
}

int main(int argc, char **argv) {
  MMPL_UDP mmpl(10000);
  mmpl.collect();
  return 0;
}
