function ui_icmt(dirfunc, stream)
% ui_icmt
% ui_icmt(dirfunc [, stream])
% dirfunc is a string specifying the name of a function
%   that specifies where data run directories are stored.
% stream is an optional argument specifying which stream
%   the run directories have recorded, e.g. 'SerIn'
if nargin < 1
  dirfunc = 'ICMTEST_DATA_DIR';
end
if nargin >= 2
  f = ne_dialg(stream, 1);
else
  f = ne_dialg('ICM20948 Vibration Sensor Test',1);
end
f = ne_dialg(f, 'add', 0, 1, 'gicmttm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'picmttmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'picmttmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'picmttmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'picmttmd', 'Disk' );
f = ne_dialg(f, 'add', 0, 1, 'gicmticm', 'ICM' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmm', 'Max' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmr', 'Rate' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'gicmticmhk', 'ICM HK' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkmlf', 'MLF' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkm', 'Mode' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkr', 'Rate' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkremainder', 'Remainder' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkmsecs', 'msecs' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhks', 'Scale' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmhkstale', 'Stale' );
f = ne_dialg(f, 'add', 0, 1, 'gicmticmg', 'ICM Gain' );
f = ne_dialg(f, 'add', 1, 0, 'picmticmgg', 'Gain' );
f = ne_listdirs(f, dirfunc, 8);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
