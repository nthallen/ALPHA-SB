#ifndef CHG_SUBBUS_H_INCLUDED
#define CHG_SUBBUS_H_INCLUDED
#include "subbuspp.h"

#if defined(SERVER) && !defined(TRANSMITTING)
  extern int subbus_quit();
#endif

extern subbuspp *B3MB;
extern bool B3MB_Initialized;

#endif
