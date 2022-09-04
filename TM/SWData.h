/* SWData.h */
#ifndef SWDATA_H_INCLUDED
#define SWDATA_H_INCLUDED

typedef struct __attribute__((__packed__)) {
  uint8_t SWStat;
  int16_t Nav_Course;
  float Nav_PGain;
  float Nav_IGain;
  float Nav_DGain;
  uint8_t Nav_Thrust_pct;
  int8_t Nav_dThrust_pct;
  uint8_t Nav_T_acc;
  uint8_t Nav_T_rot;
  uint8_t Nav_Status;
} SWData_t;
extern SWData_t SWData;

#define SWS_NAV_IDLE 10
#define SWS_NAV_PID 11
#define SWS_NAV_FF 12
#define SWS_NAV_SURVEY 13
#define SWS_NAV_PORT1 14
#define SWS_NAV_STBD1 15
#define SWS_NAV_PORT2 16
#define SWS_NAV_STBD2 17
#define SWS_ASC_OFF 30
#define SWS_ASC_ON 31
#define SWS_SHUTDOWN 255
#define SWS_PMC_ACTIVATE 20
#define SWS_PMC_STOP 21
#define SWS_PMC_LOCK 22

#endif
