/** @file PropMtr.h */
#ifndef PROPMTR_INT_H_INCLUDED
#define PROPMTR_INT_H_INCLUDED

#include "dasio/client.h"
#include "PropMtr.h"

class PropMtrCmd : public DAS_IO::Client {
  public:
    PropMtrCmd();
    ~PropMtrCmd();
    bool app_input();
  protected:
};

#endif
