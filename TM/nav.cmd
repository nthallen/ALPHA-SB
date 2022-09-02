%{
  #include <math.h>
%}
&nav_angle <int16_t>
  : %f (Enter Angle in degrees) deg
    { float ang = fmodf($1,360);
      if (ang < -180) ang += 360.;
      else if (ang > 180) ang -= 360.;
      $0 = (int16_t) (ang * 100);
    }
  ;
&nav_gain <float>
  : %f (Enter Gain Value) { $0 = $1; }
  ;
&nav_thrust_pct_v <uint8_t>
  : %d (Enter Thrust as an integer percentage) pct
    { $0 = ($1 > 100) ? 100 : (($1 < 0) ? 0 : $1); }
  ;
&nav_dthrust_pct_v <int8_t>
  : %d (Enter Differential Thrust as an integer percentage between -100 and 100) pct
    { $0 = ($1 > 100) ? 100 : (($1 < -100) ? -100 : $1); }
  ;
&nav_time_t_v <uint8_t>
  : %f (Enter time in seconds and tenths) sec
    { $0 = ($1 > 25.5) ? 255 : ($1 < 0) ? 0 : (uint8_t)($1*10); }
  ;
&nav_status_v <uint8_t>
  : Idle { $0 = 0; }
  : PID { $0 = 1; }
  : Fail { $0 = 2; }
  : FF_Init { $0 = 3; }
  : FF_Pause { $0 = 4; }
  : FF_Done { $0 = 5; }
  : Port1 { $0 = 6; }
  : Stbd1 { $0 = 7; }
  : Port2 { $0 = 8; }
  : Stbd2 { $0 = 9; }
  ;
