%INTERFACE <Sim>

&command
  : Sim Start * { if_Sim.Turf("Start\n"); }
  : Sim Quit * { if_Sim.Turf("Q\n"); }
# : Sim Noop * { if_Sim.Turf("Noop\n"); }
  : Sim Set &simvar %lf * { if_Sim.Turf("Set %s %.5lf\n", $3, $4); }
  : Sim Adjust &simvar %lf * { if_Sim.Turf("Adjust %s %.5lf\n", $3, $4); }
  ;

&simvar <const char *>
  : thrustLeft { $0 = "thrustLeft"; }
  : thrustRight { $0 = "thrustRight"; }
  : initialAltitude { $0 = "initialAltitude"; }
  : initialLatitude { $0 = "initialLatitude"; }
  : initialLongitude { $0 = "initialLongitude"; }
  : ductCdischarge { $0 = "ductCdischarge"; }
  : ductArea { $0 = "ductArea"; }
  : ductHeightRatio { $0 = "ductHeightRatio"; }
  ;
