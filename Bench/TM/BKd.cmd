%{
  #ifdef SERVER
    #include "math.h"
  #endif
%}
%INTERFACE <BKd>

&command
  : BK Voltage Set %f * {
      if ($4 < 0 || $4 > 36) {
        msg(MSG_ERROR, "BK Voltage set value out of range");
      } else {
        uint16_t Vscaled = floor($4*10 + 0.5);
        if_BKd.Turf("V:%03u\n", Vscaled);
      }
    }
  : BK Current Set %f * {
      if ($4 < 0 || $4 > 10) {
        msg(MSG_ERROR, "BK Current set value out of range");
      } else {
        uint16_t Iscaled = floor($4*10 + 0.5);
        if_BKd.Turf("I:%03u\n", Iscaled);
      }
    }
  : BK Output &BK_OnOff * { if_BKd.Turf("S:%d\n", $3); }
  : BK Quit * { if_BKd.Turf("Q\n"); }
  ;
&BK_OnOff <int>
  : On { $0 = 0; }
  : Off { $0 = 1; }
  ;

