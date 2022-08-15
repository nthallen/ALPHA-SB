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
  : Set Nav Course &Course { SWData.Course = $4; }
  : Set Nav PGain &Nav_PGain { SWData.Nav_PGain = $4; }
  : Set Nav IGain &Nav_IGain { SWData.Nav_IGain = $4; }
  : Set Nav DGain &Nav_DGain { SWData.Nav_DGain = $4; }
  : Set Nav Thrust &Nav_Thrust { SWData.Nav_Thrust = $4; }
  : Set Nav Status &Nav_Status { SWData.Nav_Status = $4; }
  ;
&SWStat <uint8_t>
  : Nav Idle { $0 = SWS_NAV_IDLE; }
  : Set %d { $0 = $2; }
  : Nav PID { $0 = SWS_NAV_PID; }
  : Nav FeedForward { $0 = SWS_NAV_FF; }
  : Nav Survey { $0 = SWS_NAV_SURVEY; }
  : Ascender Power Down { $0 = SWS_ASC_OFF; }
  : Ascender Power Up { $0 = SWS_ASC_ON; }
  : Shutdown Full { $0 = SWS_SHUTDOWN; }
  : PMC Activate { $0 = SWS_PMC_ACTIVATE; }
  : PMC Stop { $0 = SWS_PMC_STOP; }
  : PMC Lock { $0 = SWS_PMC_LOCK; }
  ;
&Course <int16_t>
  : &nav_angle { $0 = $1; }
  ;
&Nav_PGain <float>
  : &nav_gain { $0 = $1; }
  ;
&Nav_IGain <float>
  : &nav_gain { $0 = $1; }
  ;
&Nav_DGain <float>
  : &nav_gain { $0 = $1; }
  ;
&Nav_Thrust <uint8_t>
  : &nav_thrust_pct { $0 = $1; }
  ;
&Nav_Status <uint8_t>
  : &nav_status_v { $0 = $1; }
  ;
