/** @file PropMtr.h */
#ifndef PROPMTR_H_INCLUDED
#define PROPMTR_H_INCLUDED

#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  int32_t VelocityMeasured;
  int32_t VelocityDemand;
  int32_t PositionMeasured;
  int32_t PositionTarget;
  int32_t PositionDemand;
  int32_t SetPoint;
  uint16_t Status[9];
  uint16_t BusVoltage;
  uint16_t CurrentDemand;
  uint16_t CurrentMeasured;
  uint16_t AI1;
} PMC_t;

typedef struct __attribute__((__packed__)) {
  PMC_t Ctrl[2];
} PropMtr_t;

extern PropMtr_t PropMtr;

#endif
