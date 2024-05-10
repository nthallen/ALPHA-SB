#ifndef ALPHA_SB_CAN_H_INCLUDED
#define ALPHA_SB_CAN_H_INCLUDED
#include "subbuspp.h"

#define USING_CAN

#ifdef USING_CAN
  #define N_ICM20948_SENSORS 1
  #define ICM_SUBBUS_FLAVOR "CAN"
#else
  #define N_ICM20948_SENSORS 1
  #define ICM_SUBBUS_FLAVOR "serusb"
#endif

#if defined(SERVER) && !defined(TRANSMITTING)
  extern int subbus_quit();
#endif

extern subbuspp *B3MB;
extern bool B3MB_Initialized;
extern subbuspp *uDACS;
extern bool uDACS_Initialized;

#endif
