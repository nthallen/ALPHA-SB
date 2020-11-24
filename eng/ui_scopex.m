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
f = ne_dialg(f, 'add', 0, 1, 'gscopexbmbv', 'B3MB 100V1' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbva', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'pscopexbmbvs', 'Status' );
f = ne_listdirs(f, 'SCoPEx_Data_Dir', 15);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
