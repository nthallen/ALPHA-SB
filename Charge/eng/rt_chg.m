function dfs_out = rt_chg(dfs)
% dfs = rt_chg()
%   Create a data_fields object and setup all the buttons for realtime
%   plots
% dfs_out = rt_chg(dfs)
%   Use the data_fields object and setup all the buttons for realtime plots
if nargin < 1
  dfs = data_fields('title', 'SCoPEx B3MB Charging Station', ...
    'Color', [.8 .8 1], ...
    'h_leading', 8, 'v_leading', 2, ...
    'btn_fontsize', 12, ...
    'txt_fontsize', 12);
  context_level = dfs.rt_init;
else
  context_level = 1;
end
dfs.start_tab('Plots');
dfs.start_col;
dfs.plot('ptm', 'label', 'T Mbase', 'plots', {'ptmtd','ptmcpu','ptmram','ptmd'});
dfs.plot('ptmtd','label','T Drift','vars',{'SysTDrift'});
dfs.plot('ptmcpu','label','CPU','vars',{'CPU_Pct'});
dfs.plot('ptmram','label','RAM','vars',{'memused'});
dfs.plot('ptmd','label','Disk','vars',{'Disk'});
dfs.plot('pbk', 'label', 'B Kd', 'plots', {'pbkv','pbka','pbks','pbkstale'});
dfs.plot('pbkv','label','Volts','vars',{'BKd_V_set','BKd_V_disp'});
dfs.plot('pbka','label','Amps','vars',{'BKd_I_set','BKd_I_disp'});
dfs.plot('pbks','label','Status','vars',{{'name','BKd_Output','var_name','BKd_Status','bit_number',0},{'name','BK_Stale','var_name','BKd_Status','bit_number',1}});
dfs.plot('pbkstale','label','Stale','vars',{'BKd_Stale'});
dfs.end_tab;
dfs.end_col;
dfs.resize(context_level);
dfs.set_connection('127.0.0.1', 1080);
if nargout > 0
  dfs_out = dfs;
end
