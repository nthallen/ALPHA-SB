#ifndef SUBBUS_LOAD_H_INCLUDED
#define SUBBUS_LOAD_H_INCLUDED
#include "subbuspp.h"

#if defined(SERVER) && !defined(TRANSMITTING)
  extern int subbus_quit();
#endif

extern subbuspp *B3MB;
extern bool B3MB_Initialized;

#endif
