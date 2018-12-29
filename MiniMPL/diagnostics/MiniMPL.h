#ifndef MINIMPL_H_INCLUDED
#define MINIMPL_H_INCLUDED
#include <stdint.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

enum MMPL_MsgType {
  Msg_MMPL_NRB=1,
  Msg_MMPL_Status,
  Msg_MMPL_Open=100,
  Msg_MMPL_Start,
  Msg_MMPL_Stop};

typedef struct {
  char Sync[2]; // 'M', 'P'
  int32_t MsgType; // Open, Start, Stop
  int32_t Size; // 0 Number of bytes following the header
} __attribute__((packed)) MMPL_Command_t;

typedef struct {
  char Sync[2]; // 'M', 'P'
  int32_t MsgType; // 2 Msg_MMPL_Status for status
  int32_t Size; // 16 Number of bytes following the header
  int32_t CmdCount; // Number of accepted UDP commands
  int32_t HWFound; // 0: not opened 1: open was successful
  int32_t Enable; // 1 if collection is enabled
  uint32_t ProfCount; // Count of profiles collected
} __attribute__((packed)) MMPL_Status_t;

/** Maximum number of bins 100-15000 m at 5m resolution, rounded up.
 */
#define MMPL_MAX_BINS 3000
typedef struct {
  char Sync[2]; // 'M', 'P'
  int32_t MsgType; // 1 Msg_MMPL_NRB for NRB
  int32_t Size; // 16 + ('N'*4) Number of bytes following the header
  uint32_t Seconds; // GPS or PC time. Should be UTC seconds since midnight
  int32_t NBins; // Number of bins
  float BinWidth; // size of each bin in meters
  float BinDist; // distance from MPL that the first bin covers
  float NRBdata[MMPL_MAX_BINS];
} __attribute__((packed)) MMPL_NRB_t;

typedef union {
  MMPL_Status_t status;
  MMPL_NRB_t NRB;
} MMPL_Data_t;

class MMPL_UDP {
  public:
    MMPL_UDP(int port);
    ~MMPL_UDP();
    void collect();
  private:
    const char *timefmt();
    int fd;
    int port; // may not need it.
    MMPL_Data_t ibuf;
    MMPL_Command_t obuf;
    struct timespec now;
    char time_string[10];
};

class MMPL_Send {
  public:
    MMPL_Send(const char *hostname, int port);
    ~MMPL_Send();
    void transmit(const char *);
  private:
    int fd;
    int port;
    struct addrinfo *addrs;
};
#endif
