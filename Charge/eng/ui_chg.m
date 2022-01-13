function ui_chg
f = ne_dialg('SCoPEx B3MB Charging Station',1);
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'Plots');
f = ne_dialg(f, 'add', 0, 1, 'gchgptm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'pchgptmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pchgptmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'pchgptmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'pchgptmd', 'Disk' );
f = ne_dialg(f, 'add', 0, 1, 'gchgpbk', 'B Kd' );
f = ne_dialg(f, 'add', 1, 0, 'pchgpbkv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'pchgpbka', 'Amps' );
f = ne_dialg(f, 'add', 1, 0, 'pchgpbks', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'pchgpbkstale', 'Stale' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'newtab', 'Runs');
f = ne_listdirs(f, 'Charge_Data_Dir', 8);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');