function ui_scopex
f = ne_dialg('SCoPEx Platform',1);
f = ne_dialg(f, 'add', 0, 1, 'gscopexs', 'System' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexssws', 'SW Stat' );
f = ne_dialg(f, 'add', 0, 1, 'gscopextm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'pscopextmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pscopextmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'pscopextmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopextmd', 'Disk' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmc', 'PMC' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcs', 'Stale' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmcl', 'PMC Left' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclrpm', 'RPM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclp', 'Position' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmcls', 'PMC Left S' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclss', 'Status 0' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus1', 'Status 1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus2', 'Status 2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus3', 'Status 3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus4', 'Status 4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus5', 'Status 5' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclsstatus6', 'Status 6' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmclg', 'PMC Left G' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmclgg', 'Gains' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmcr', 'PMC Right' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrrpm', 'RPM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrp', 'Position' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmcrs', 'PMC Right S' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrss', 'Status 0' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus1', 'Status 1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus2', 'Status 2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus3', 'Status 3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus4', 'Status 4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus5', 'Status 5' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrsstatus6', 'Status 6' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexpmcrg', 'PMC Right G' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexpmcrgg', 'Gains' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexbmbvb', 'B3MB 28V1 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvbv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvba', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvbt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvbs', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvbf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexbmbvl', 'B3MB 28V1 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvlv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvla', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvls', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvlf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_28v2_batt', 'B3MB 28V2 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_battv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_batta', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_battt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_28v2_load', 'B3MB 28V2 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_loadv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_loada', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_28v2_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v1_batt', 'B3MB 100V1 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_battv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_batta', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_battt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v1_load', 'B3MB 100V1 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_loadv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_loada', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v1_loadf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v2_batt', 'B3MB 100V2 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_battv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_batta', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_battt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_battf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v2_load', 'B3MB 100V2 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_loadv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_loada', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v2_loadf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v3_batt', 'B3MB 100V3 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_battv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_batta', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_battt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_100v3_load', 'B3MB 100V3 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_loadv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_loada', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_100v3_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexgnss', 'GNSS' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnsss', 'System' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssf', 'Filters' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssd', 'Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssp', 'Position' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssv', 'Velocity' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssa', 'Accel' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssattitude', 'Attitude' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssav', 'Ang Vel' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssstd', 'Std' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexgnssstale', 'Stale' );
f = ne_listdirs(f, 'SCoPEx_Data_Dir', 15);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
