#ifndef DUALSIM_H_INCLUDED
#define DUALSIM_H_INCLUDED

#include "dasio/serial.h"
#include "SpatialDual.h"

class dualsim : public DAS_IO::Serial {
  public:
    dualsim(const char *port, int baud, ALPHA_SB *model);
    bool protocol_input();
  private:
    ALPHA_SB *model;
    struct __attribute__((__packed__)) {
      struct __attribute__((__packed__)) {
        uint8_t LRC;
        uint8_t ID;
        uint8_t length;
        uint16_t CRC;
      } hdr;
      system_status_t status;
    } tx;
};

#endif
