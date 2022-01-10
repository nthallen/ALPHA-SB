/** @file BKd.h
 * BK Precision 1687B Bench Power Supply Driver Telemetry Definitions
 */
#ifndef BKD_H_INCLUDED
#define BKD_H_INCLUDED
#include <stdint.h>

typedef struct {
  uint16_t V_set; /**< decivolts (fixed point 1 decimal place) */
  uint16_t I_set; /**< deciamps (fixed point 1 decimal place) */
  uint16_t V_disp; /**< centivolts (fixed point 2 decimal places) */
  uint16_t I_disp; /**< centiamps (fixed point 2 decimal places) */
  uint8_t Status; /**< 0 => ON, 1 => OFF, 0 => Fresh, 2 => Stale */
} BKd_t;

extern BKd_t BKd;

#endif
