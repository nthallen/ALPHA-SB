function ui_scopex
f = ne_dialg('SCoPEx Platform',1);
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'Main');
f = ne_dialg(f, 'add', 0, 1, 'gscopexms', 'System' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmssws', 'SW Stat' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexmtm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmtmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmtmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmtmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmtmd', 'Disk' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmgnss', 'GNSS' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnsss', 'System' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssf', 'Filters' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssd', 'Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssll', 'Lat Lon' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssa', 'Altitude' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssp', 'Position' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssv', 'Velocity' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssh', 'Heading' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssaccel', 'Accel' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssattitude', 'Attitude' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssav', 'Ang Vel' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssstd', 'Std' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmgnssstale', 'Stale' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexma', 'Ascender' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmap', 'Pos' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmas', 'Speed' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmac', 'Cmd' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmal', 'Limits' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmahk', 'Asc HK' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahkv', 'V' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahki', 'I' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahkci', 'Ctrl Inp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahkm', 'Mode' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahkt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahkn', 'Nreports' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmahks', 'Stale' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmn', 'Nav' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmng', 'Gains' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmnt', 'Thrust' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmndthrust', 'd Thrust' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmntiming', 'Timing' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmns', 'Status' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'Motors');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmc', 'PMC' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcs', 'Stale' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmcl', 'PMC Left' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclrpm', 'RPM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclp', 'Position' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmcls', 'PMC Left S' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclss', 'Status 0' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus1', 'Status 1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus2', 'Status 2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus3', 'Status 3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus4', 'Status 4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus5', 'Status 5' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclsstatus6', 'Status 6' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmclg', 'PMC Left G' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmclgg', 'Gains' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmcr', 'PMC Right' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrrpm', 'RPM' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrp', 'Position' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmcrs', 'PMC Right S' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrss', 'Status 0' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus1', 'Status 1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus2', 'Status 2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus3', 'Status 3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus4', 'Status 4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus5', 'Status 5' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrsstatus6', 'Status 6' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexmpmcrg', 'PMC Right G' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexmpmcrgg', 'Gains' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'B3MB');
f = ne_dialg(f, 'add', 0, 1, 'gscopexbmbbmbvb', 'B3MB 28V1 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvbvv', 'Volts 28V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvbav', 'Amps 28V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvbtv', 'Temp 28V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvbs', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvbf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexbmbbmbvl', 'B3MB 28V1 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvlvv', 'Volts 28V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvlav', 'Amps 28V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvls', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbbmbvlf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_28v2_batt', 'B3MB 28V2 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_battvv', 'Volts 28V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_battav', 'Amps 28V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_batttv', 'Temp 28V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_28v2_load', 'B3MB 28V2 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_loadvv', 'Volts 28V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_loadav', 'Amps 28V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_28v2_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v1_batt', 'B3MB 100V1 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_battvv', 'Volts 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_battav', 'Amps 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_batttv', 'Temp 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v1_load', 'B3MB 100V1 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_loadvv', 'Volts 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_loadav', 'Amps 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v1_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v2_batt', 'B3MB 100V2 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_battvv', 'Volts 100V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_battav', 'Amps 100V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_batttv', 'Temp 100V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v2_load', 'B3MB 100V2 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_loadvv', 'Volts 100V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_loadav', 'Amps 100V2' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v2_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v3_batt', 'B3MB 100V3 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_battvv', 'Volts 100V3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_battav', 'Amps 100V3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_batttv', 'Temp 100V3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v3_load', 'B3MB 100V3 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_loadvv', 'Volts 100V3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_loadav', 'Amps 100V3' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v3_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v4_batt', 'B3MB 100V4 Batt' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_battvv', 'Volts 100V4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_battav', 'Amps 100V4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_batttv', 'Temp 100V4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_batts', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_battf', 'Fault' );
f = ne_dialg(f, 'add', 0, 1, 'gscopexb3mb_b3mb_100v4_load', 'B3MB 100V4 Load' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_loadvv', 'Volts 100V4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_loadav', 'Amps 100V4' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_loads', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexb3mb_b3mb_100v4_loadf', 'Fault' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'Runs');
f = ne_listdirs(f, 'SCoPEx_Data_Dir', 8);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
