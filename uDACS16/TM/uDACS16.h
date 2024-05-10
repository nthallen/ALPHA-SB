/* uDACS16.h */
#ifndef UDACS16_H_INCLUDED
#define UDACS16_H_INCLUDED
#include <cstdint>

#define USING_CAN

#ifdef USING_CAN
  #define N_UDACS16 1
  #define ICM_SUBBUS_FLAVOR "CAN"
#else
  #define N_UDACS16 1
  #define ICM_SUBBUS_FLAVOR "serusb"
#endif

typedef struct {
  int16_t max_accel[3];
  uint16_t samples_per_sec;
  int16_t temp[2];
  uint8_t status; // contains, mode, fs, and anything else
  uint8_t padding;
} uDACS16_dev;

typedef struct {
  uDACS16_dev dev[N_UDACS16];
} uDACS16_t;

extern uDACS16_t uDACS16;

#endif
