#ifndef HALSA_H_INCLUDED
#define HALSA_H_INCLUDED

#include <time.h>
#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  double  Time;          // secs since 1970, msec resolution
  int32_t elapsed_msecs; // Good for about 45 days
  float   deflection;    // degrees, resolution TBD
  float   velocity;      // m/s, resolution TBD
  float   temperature;   // Celcius, resolution TBD
  float   std_def;       // std of deflection
  uint8_t n_detected;    // Number of circles detected
  uint8_t Stale;         // Seconds since we received data
                         // from HALSA instrument
} HALSA_t;
extern HALSA_t HALSA;

#endif
