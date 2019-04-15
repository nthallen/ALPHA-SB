/** @file PropMtr_int.h */
#ifndef PROPMTR_INT_H_INCLUDED
#define PROPMTR_INT_H_INCLUDED

#include "dasio/client.h"
#include "dasio/modbus_rtu.h"
#include "PropMtr.h"

class PropMtrCmd : public DAS_IO::Client {
  public:
    PropMtrCmd(DAS_IO::Modbus::RTU *MB);
    ~PropMtrCmd();
    bool app_input();
  protected:
    DAS_IO::Modbus::RTU *MB;
};

extern const char *PropMtr_port;

#endif
