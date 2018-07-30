#include <unistd.h>
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

MMPL_Send::MMPL_Send(const char *hostname, int port) {
  char service[10];
  struct addrinfo hints, *p;
  int err;

  if (port == 0)
    nl_error( 3, "Invalid port in Bind: 0" );
  snprintf(service, 10, "%d", port);
  this->port = port;

  memset(&hints, 0, sizeof(hints));	
  hints.ai_family = AF_UNSPEC;		// don't care IPv4 or v6
  hints.ai_socktype = SOCK_DGRAM;
  hints.ai_flags = AI_PASSIVE;

  err = getaddrinfo(hostname, 
                    service,
                    &hints,
                    addrs);
  if (err)
    nl_error( 3, "Bind: getaddrinfo error: %s", gai_strerror(err) );
  if (addrs->ai_next)
    nl_error( 1, "More than one address found for %s:%d", hostname, port);
  p = results;
  fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
  if (fd < 0)
    nl_error( 2, "MMPL_Send socket error: %s", strerror(errno) );
    
  // ioflags = fcntl(fd, F_GETFL, 0);
  // if (ioflags != -1)
    // ioflags = fcntl(fd, F_SETFL, ioflags | O_NONBLOCK);
  // if (ioflags == -1)
    // nl_error( 3, "Error setting O_NONBLOCK on UDP socket: %s",
      // strerror(errno));
}

MMPL_Send::~MMPL_Send() {}

void MMPL_Send::transmit(const char *cmd) {
  int cmdtype, nc;
  MMPL_Command_t msg;
  if (strcasecmp("Open", cmd) == 0) {
    cmdtype = Msg_MMPL_Open;
  } else if (strcasecmp("Start", cmd) == 0) {
    cmdtype = Msg_MMPL_Start;
  } else if (strcasecmp("Stop", cmd) == 0) {
    cmdtype = Msg_MMPL_Stop;
  } else nl_error(2, "Unrecognized command '%s'", cmd);
  msg.Sync[0] = 'M';
  msg.Sync[1] = 'P';
  msg.MsgType = cmdtype;
  msg.Size = 0;
  nc = sendto(fd, &msg, sizeof(msg), 0,
            addr, sizeof(struct addrinfo));
  // nc = write(fd, &msg, sizeof(msg));
  if (nc < 0) {
    nl_error(2, "Error %d on sendto: %s", errno, strerror(errno));
  } else if (nc != sizeof(msg)) {
    nl_error(2, "write returned %d, not %d", nc, sizeof(msg));
  }
}

int main(int argc, char **argv) {
  int i;
  MMPL_Send mmpl("hclgse.arp.harvard.edu", 10000);
  for (i = 1; i < argc; ++i)
    mmpl.transmit(argv[i]);
  return 0;
}
