%{
  #ifdef SERVER
    #include "math.h"
  #endif
%}
%INTERFACE <MPSLd>

&command
  : MPSL Voltage Set %f * {
      if ($4 < 0 || $4 > 125) {
        msg(MSG_ERROR, "MPSL Voltage set value out of range");
      } else {
        if_MPSLd.Turf("V:%f\n", $4);
      }
    }
  : MPSL Current Set %f * {
      if ($4 < 0 || $4 > 20) {
        msg(MSG_ERROR, "MPSL Current set value out of range");
      } else {
        if_MPSLd.Turf("I:%f\n", $4);
      }
    }
  : MPSL Output &MPSL_OnOff * { if_MPSLd.Turf("S:%d\n", $3); }
  : MPSL Configure Setpoint &MPSL_Setpt * { if_MPSLd.Turf("C:%d\n", $4); }
  : MPSL Quit * { if_MPSLd.Turf("Q\n"); }
  ;
&MPSL_OnOff <int>
  : On { $0 = 1; }
  : Off { $0 = 0; }
  ;
&MPSL_Setpt <int>
  : Rotary { $0 = 0; }
  : Remote { $0 = 3; }
  ;
