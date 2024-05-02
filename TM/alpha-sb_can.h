#ifndef ALPHA_SB_CAN_H_INCLUDED
#define ALPHA_SB_CAN_H_INCLUDED
#include "subbuspp.h"
#include "ICM20948.h"

  #if defined(SERVER) && !defined(TRANSMITTING)
  extern int subbus_quit();
#endif

extern subbuspp *B3MB;
extern bool B3MB_Initialized;
extern subbuspp *uDACS;
extern bool uDACS_Initialized;

#endif
