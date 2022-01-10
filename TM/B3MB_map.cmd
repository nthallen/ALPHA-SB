# B3MB_map.cmd
# 28V1(2)  L1(8)  is Port Engine 28V
# 100V1(6) L1(8)  is Port Engine 100V
# 28V1(2)  L2(10) is Data System 28V
# 28V1(2)  L4(14) is Starboard Engine 28V
# 100Vy(x) Ln(mm) is Starboard Engine 100V
# 100V1(6) L2(10) is Ascender N1
# 100V2(7) L2(10) is Ascender N2
# 100V3(8) L2(10) is Ascender N3
# 100V4(3) L2(10) is Ascender N4

&^command
  : B3MB Port Engine 28V &B3MB_On_Off * { B3MB_command(2,8,$5); }
  : B3MB Port Engine 100V &B3MB_On_Off * { B3MB_command(6,8,$5); }
  : B3MB Data System 28V &B3MB_On_Off * { B3MB_command(2,10,$5); }
  : B3MB Starboard Engine 28V &B3MB_On_Off * { B3MB_command(2,14,$5); }
  : B3MB Ascender N1 &B3MB_On_Off * { B3MB_command(6,10,$4); }
  : B3MB Ascender N2 &B3MB_On_Off * { B3MB_command(7,10,$4); }
  : B3MB Ascender N3 &B3MB_On_Off * { B3MB_command(8,10,$4); }
  : B3MB Ascender N4 &B3MB_On_Off * { B3MB_command(3,10,$4); }
  : B3MB Ascender All &B3MB_On_Off * {
      B3MB_command(6,10,$4);
      B3MB_command(7,10,$4);
      B3MB_command(8,10,$4);
      B3MB_command(3,10,$4);
    }
  ;
