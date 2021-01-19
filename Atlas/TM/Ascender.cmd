%INTERFACE <ascender>

&command
  : Ascender Set Speed %d (-100 to 100 percent) %% * {
      int speed = $4;
      if (speed > 100) speed = 100;
      if (speed < -100) speed = -100;
      if_ascender.Turf("W%d\n", speed);
    }
  : Ascender Quit * {
      if_ascender.Turf("Q\n");
    }
  ;
