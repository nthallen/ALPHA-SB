/** @file PropMtr.h */
#ifndef PROPMTR_H_INCLUDED
#define PROPMTR_H_INCLUDED
/*
  Apparently the 32-bit registers are truly BigEndian
  and need to be swapped from 4321 order.
  16-bit values need to be byte-swapped.
  Max Accel/Decel are 32-bit but explicitly listed as
    two 16-bit registers with the LSW first, so they
    need to be read as 16-bit registers (2143 order)

  Channels are listed here in mode/addr/count with
  notation to clarify 16- and 32-bit reads.

  int32_t VelocityMeasured; // 4/251/4 (32-bit)
  int32_t VelocityDemand;   // 4/253/- (32-bit)
  int32_t PositionMeasured; // 4/257/6 (32-bit)
  int32_t PositionTarget;   // 4/259/- (32-bit)
  int32_t PositionDemand;   // 4/261/- (32-bit)
  int32_t SetPoint; // Interface Input 1: 3/321/2 (32-bit)
  uint16_t Status[7];       // 4/5/11 (16-bit)
  uint16_t BusVoltage;      // 4/12/-
  uint16_t CurrentDemand;   // 4/13/- (current demand torque)
  uint16_t CurrentMeasured; // 4/14/- (current measured torque)
  // uint16_t AI1;          // 4/15/- (analog input)


  uint16_t // 3/46/1 Torque Current Loop Proportional Gain (16-bit)
  uint16_t // 3/47/1 Torque Current Loop Integral Gain (16-bit)
  uint32_t // 3/251/2 Velocity Loop Proportional Gain: Set 0 (32-bit)
  uint32_t // 3/253/2 Velocity Loop Integral Gain: Set 0 (32-bit)
  uint32_t // 3/255/2 Velocity Loop Derivative Gain: Set 0 (32-bit)

*/

#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  int32_t  VelocityDemand;   // 4/253/2(32) -
  int32_t  PositionMeasured; // 4/257/2(32) /6
  int32_t  PositionTarget;   // 4/259/2(32)
  int32_t  PositionDemand;   // 4/261/2(32)
  int32_t  VL_Kp;            // 3/251/2(32) /6
  int32_t  VL_Ki;            // 3/253/2(32)
  int32_t  VL_Kd;            // 3/255/2(32)
  int32_t  SetPoint;         // 3/321/2(32) -
  int16_t  TCL_Kp;           // 3/46/1(16) /2
  int16_t  TCL_Ki;           // 3/47/1(16)
  uint16_t Status[7];        // 4/5/7(16) -
  uint16_t BusVoltage;       // 4/12/1(16) /2
  uint16_t CurrentDemand;    // 4/13/1(16)
} PMC_t;

typedef struct __attribute__((__packed__)) {
  int32_t  VelocityMeasured; // 4/251/2(32) -
  uint16_t CurrentMeasured;  // 4/14/1(16) -
} PMC_fast_t;

typedef struct __attribute__((__packed__)) {
  PMC_t Ctrl[2];
} PropMtr_t;

typedef struct __attribute__((__packed__)) {
  PMC_fast_t Ctrl[2];
} PropMtr_fast_t;

extern PropMtr_t PropMtr;
extern PropMtr_fast_t PropMtr_fast;

#endif
