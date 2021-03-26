%{
  #include "SWData.h"
  #ifdef SERVER
    SWData_t SWData;
  #endif
%}

%INTERFACE <SWData:DG/data>

&^command
  : &SWTM * { if_SWData.Turf(); }
  ;
&SWTM
  : SW Status &SWStat { SWData.SWStat = $3; }
  ;
&SWStat <uint8_t>
  : Shutdown Full { $0 = SWS_SHUTDOWN; }
  : Set %d { $0 = $2; }
  : PMC Activate { $0 = SWS_PMC_ACTIVATE; }
  : PMC Stop { $0 = SWS_PMC_STOP; }
  : PMC Lock { $0 = SWS_PMC_LOCK; }
  ;
