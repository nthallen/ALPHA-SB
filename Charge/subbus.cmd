%{
  #include "subbus_load.h"

  #if defined(SERVER) && !defined(TRANSMITTING)
    int subbus_quit() {
      return(B3MB->subbus_quit());
    }
  #endif
%}
