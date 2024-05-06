%{
  #include "alpha-sb_can.h"

  #if defined(SERVER) && !defined(TRANSMITTING)
    /* Returns zero if both calls are successful */
    int subbus_quit() {
      return(B3MB->subbus_quit() | uDACS->subbus_quit());
    }
  #endif
%}
