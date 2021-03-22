%INTERFACE <ascender>

&command
  : Ascender Set Speed %d (-100 to 100 percent) pct For %d &Asc_units * {
      int speed = $4;
      int duration = $7 * $8;
      if (speed > 100) speed = 100;
      if (speed < -100) speed = -100;
      if_ascender.Turf("W%d:%d\n", speed, duration);
    }
  : Ascender Stop * {
      if_ascender.Turf("W0:0\n");
    }
  : Ascender Quit * {
      if_ascender.Turf("Q\n");
    }
  ;

&Asc_units <int>
  : min { $0 = 60000; }
  : sec { $0 = 1000; }
  : msec { $0 = 1; }
  ;
