%{
%}
%INTERFACE <ICM20948>

&command
  : ICM Select &icm_mode * { if_ICM20948.Turf("M%d\n", $3); }
  : ICM Select Full Scale &icm_fs * { if_ICM20948.Turf("F%d\n", $5); }
  : ICM Quit * { if_ICM20948.Turf("Q\n"); }
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
