%{
%}
%INTERFACE <ICM20948>

&command
  : ICM Select &icm_mode * { if_ICM20948.Turf("M%d\n", $3); }
  : ICM Select Full Scale &icm_fs * { if_ICM20948.Turf("F%d\n", $5); }
  : ICM Quit * { if_ICM20948.Turf("Q\n"); }
  : ICM Set Gain &icm_gain &icm_gain_val * {
      if_ICM20948.Turf("%c%10.3le\n", $4, $5); }
  : ICM Set Target Remainder %d * {
      if_ICM20948.Turf("R%d\n", $5); }
  ;

&icm_mode <int>
  : Idle Mode { $0 = 0; }
  : Slow Mode { $0 = 1; }
  : Fast Mode { $0 = 2; }
  ;

&icm_fs <int>
  : 2g { $0 = 0; }
  : 4g { $0 = 1; }
  : 8g { $0 = 2; }
  : 16g { $0 = 3; }
  ;

&icm_gain <char>
  : Gp { $0 = 'P'; }
  : Gi { $0 = 'I'; }
  ;

&icm_gain_val <float>
  : %f { $0 = $1; }
  ;
