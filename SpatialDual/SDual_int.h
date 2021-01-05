#ifndef SDUAL_H_INCLUDED
#define SDUAL_H_INCLUDED

#include "SpatialDual.h"

extern const char *SDual_port;
extern int SDual_baud;

class SDual : public DAS_IO::Serial {
  public:
    SDual();
  protected:
};

#endif