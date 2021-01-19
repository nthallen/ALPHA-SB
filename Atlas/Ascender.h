#ifndef ASCENDER_H_INCLUDED
#define ASCENDER_H_INCLUDED
#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  uint16_t HoistV;
   int16_t Position;
  uint8_t  Status;
  uint8_t  HoiseI;
   int8_t  SpeedCmd;
  uint8_t  Nreports;
   int8_t  Temp[4];
} ascender_t;

extern ascender_t Ascender;

#endif
