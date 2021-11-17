#ifndef SDUAL_H_INCLUDED
#define SDUAL_H_INCLUDED

#include "dasio/server.h"
#include "dasio/tm_data_sndr.h"
#include "SpatialDual.h"

extern const char *SDual_port;
extern int SDual_baud;
extern bool SDual_sim;

using namespace DAS_IO;

class SDual : public Serverside_client {
  public:
    SDual(Authenticator *Auth, const char *iname);
    static inline void set_TM(TM_data_sndr *TM) { SDual::TM = TM; }
  protected:
    bool protocol_input();
    bool report_system_state(system_status_t *recd);
    bool tm_sync();
    
    struct __attribute__((__packed__)) frame_hdr_t {
      uint8_t LRC;
      uint8_t Packet_ID;
      uint8_t Packet_len;
      uint16_t CRC;
    } *hdr;
    static TM_data_sndr *TM;
};

SDual *new_SDual_socket(Authenticator *,SubService *);

#endif