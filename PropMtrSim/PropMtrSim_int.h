/** @file PropMtr_int.h */
#ifndef PROPMTR_INT_H_INCLUDED
#define PROPMTR_INT_H_INCLUDED

#include "dasio/tm_data_sndr.h"
#include "dasio/cmd_reader.h"
#include "PropMtr.h"

class PropMtrTMf : public DAS_IO::TM_data_sndr {
  public:
    PropMtrTMf(const char *iname, const char *datum,
              const void *data, uint16_t size);
  protected:
    bool app_input();
};

class PropMtrCmd : public DAS_IO::Cmd_reader {
  public:
    PropMtrCmd();
    bool app_input();
  protected:
    void clear_to_newline();
};

extern int32_t SimRate;

#endif
