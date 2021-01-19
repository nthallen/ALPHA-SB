#ifndef ASCENDER_H_INCLUDED
#define ASCENDER_H_INCLUDED
#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  uint16_t HoistV;
   int16_t Position;
  uint8_t  Status;
  uint8_t  HoistI;
   int8_t  SpeedCmd;
   int8_t  Speed;
   int8_t  Temp[4];
  uint8_t  Nreports;
} ascender_t;

extern ascender_t Ascender;

#endif
