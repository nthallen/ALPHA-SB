%{
  #include <math.h>
%}
&nav_angle <uint16_t>
  : %f (Enter Positive Angle in degrees)
    { float ang = fmodf($1,360);
      if (ang < 0) ang += 360.;
      $0 = (uint16_t) (ang * 65536. / 360.);
    }
  ;
&nav_gain <float>
  : %f (Enter Gain Value) { $0 = $1; }
  ;
&nav_thrust_pct <uint8_t>
  : %d (Enter Thrust as an integer percentage)
    { $0 = ($1 > 100) ? 100 : (($1 < 0) ? 0 : $1); }
  ;
