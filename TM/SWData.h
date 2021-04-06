/* SWData.h */
#ifndef SWDATA_H_INCLUDED
#define SWDATA_H_INCLUDED

typedef struct __attribute__((__packed__)) {
  uint8_t SWStat;
  uint16_t Course;
  float Nav_PGain;
  float Nav_IGain;
  float Nav_DGain;
  uint8_t Nav_Thrust;
} SWData_t;
extern SWData_t SWData;

#define SWS_SHUTDOWN 255
#define SWS_PMC_ACTIVATE 20
#define SWS_PMC_STOP 21
#define SWS_PMC_LOCK 22

#endif
