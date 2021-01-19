#ifndef ASCENDER_INT_H_INCLUDED
#define ASCENDER_INT_H_INCLUDED

#include "dasio/serial.h"
#include "Ascender.h"

using namespace DAS_IO;

class Ascend : public Serial {
  public:
    Ascend(const char *iname, const char *port);
    bool SetSpeed(int32_t percent);
  protected:
    bool protocol_input();
    bool not_range_input(int32_t &val, const char *vname,
      int32_t min, int32_t max);
};

class AscendCmd : public Cmd_reader {
  public:
    AscendCmd(Ascend *Device);
  protected:
    bool app_input();
    Ascend *Device;
};

#endif
