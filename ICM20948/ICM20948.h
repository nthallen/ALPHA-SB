/* ICM20948.h */
#ifndef ICM20948_H_INCLUDED
#define ICM20948_H_INCLUDED
#include <cstdint>

#define USING_CAN

#ifdef USING_CAN
  #define N_ICM20948_SENSORS 1
  #define ICM_SUBBUS_FLAVOR "CAN"
#else
  #define N_ICM20948_SENSORS 1
  #define ICM_SUBBUS_FLAVOR "serusb"
#endif

#define N_ICM20948_PEAKS 3

typedef struct {
  int16_t max_accel[3];
  struct {
    uint16_t freq_index;
    uint16_t amplitude;
  } peaks[N_ICM20948_PEAKS];
  uint16_t samples_per_sec;
  uint16_t remainder[2];
  uint16_t msecs;
  uint8_t mode;
  uint8_t status;
} ICM20948_dev;

typedef struct {
  // double Gp, Gi;
  uint32_t mlf_file;
  ICM20948_dev dev[N_ICM20948_SENSORS];
} ICM20948_t;

extern ICM20948_t ICM20948;

#endif
