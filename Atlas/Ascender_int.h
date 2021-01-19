#ifndef ASCENDER_INT_H_INCLUDED
#define ASCENDER_INT_H_INCLUDED

#include "dasio/serial.h"
#include "dasio/cmd_reader.h"
#include "Ascender.h"

using namespace DAS_IO;

class Ascend : public Serial {
  public:
    Ascend(const char *iname);
    bool SetSpeed(int32_t percent);
    static const char *Ascender_port;
  protected:
    bool protocol_input();
    bool tm_sync();
    bool not_range_input(int16_t &val, const char *vname,
      int fix, int32_t min, int32_t max);
};

class AscendCmd : public Cmd_reader {
  public:
    AscendCmd(Ascend *Device);
  protected:
    bool app_input();
    Ascend *Device;
};

#endif
