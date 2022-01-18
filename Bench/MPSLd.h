/** @file MPSLd.h
 * Magna-Power SL Series Bench Power Supply Driver Telemetry Definitions
 */
#ifndef MPSLD_H_INCLUDED
#define MPSLD_H_INCLUDED
#include <stdint.h>

typedef struct {
  uint16_t V_set; /**< decivolts (fixed point 1 decimal place) */
  uint16_t I_set; /**< deciamps (fixed point 1 decimal place) */
  uint16_t V_disp; /**< centivolts (fixed point 2 decimal places) */
  uint16_t I_disp; /**< centiamps (fixed point 2 decimal places) */
   /**
    * Bit-mapped data from STAT:COND?
    * Bit 0: ARM:  Arm (not on SL)
    * Bit 1: SS:   Soft Start
    * Bit 2: LOCK: Locked
    * Bit 3: INT:  Internal Control
    * Bit 4: EXT:  External Control
    * Bit 5: WTG:  Interface is Waiting for Trigger
    * Bit 6: STBY: Standby
    * Bit 7: PWR:  Power
    * Bit 8: CV:   Constant Voltage
    * Bit 9: RSEN: Remote Sense
    * Bit 10: CC:  Constant Current
    * Bit 11: STBY_ALM: Standby or Alarm
    * Bit 12: NU:  Not Used
    *
    * May map additional bits to driver status info.
    * Bit 13: OUTP
    * Bit 14: SETPT
    * Could include the value from OUTP? (which could be redundant?)
    * I am guessing OUTP:START would set bit 7 while OUTP:STOP
    * would set bit 6 and 11
    */
  uint16_t Status;
} MPSLd_t;

extern MPSLd_t MPSLd;

#endif
