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
dfs.plot('pbk', 'label', 'B Kd', 'plots', {'pbkv','pbka','pbks','pbkstale'});
dfs.plot('pbkv','label','Volts','vars',{'BKd_V_limit','BKd_V_set','BKd_V_disp'});
dfs.plot('pbka','label','Amps','vars',{'BKd_I_set','BKd_I_disp'});
dfs.plot('pbks','label','Status','vars',{{'name','BKd_Output','var_name','BKd_Status','bit_number',0},{'name','BK_Stale','var_name','BKd_Status','bit_number',1}});
dfs.plot('pbkstale','label','Stale','vars',{'BKd_Stale'});
dfs.plot('pmpsl', 'label', 'MPS Ld', 'plots', {'pmpslv','pmpsla','pmpsls','pmpslstale'});
dfs.plot('pmpslv','label','Volts','vars',{'MPSLd_V_limit','MPSLd_V_set','MPSLd_V_disp'});
dfs.plot('pmpsla','label','Amps','vars',{'MPSLd_I_set','MPSLd_I_disp'});
dfs.plot('pmpsls','label','Status','vars',{{'name','MPSLd_SS','var_name','MPSLd_Status','bit_number',1},{'name','MPSLd_STBY','var_name','MPSLd_Status','bit_number',6},{'name','MPSLd_PWR','var_name','MPSLd_Status','bit_number',7},{'name','MPSLd_CV','var_name','MPSLd_Status','bit_number',8},{'name','MPSLd_CC','var_name','MPSLd_Status','bit_number',10},{'name','MPSLd_Output','var_name','MPSLd_Status','bit_number',13},{'name','MPSLd_Setpt','var_name','MPSLd_Status','bit_number',14}});
dfs.plot('pmpslstale','label','Stale','vars',{'MPSLd_Stale'});
dfs.end_col;
dfs.start_col;
dfs.plot('ptm', 'label', 'T Mbase', 'plots', {'ptmtd','ptmcpu','ptmram','ptmd'});
dfs.plot('ptmtd','label','T Drift','vars',{'SysTDrift'});
dfs.plot('ptmcpu','label','CPU','vars',{'CPU_Pct'});
dfs.plot('ptmram','label','RAM','vars',{'memused'});
dfs.plot('ptmd','label','Disk','vars',{'Disk'});
dfs.end_tab;
dfs.start_tab('B3MB');
dfs.start_col;
dfs.plot('bmbbmbvb', 'label', 'B3MB 28V1 Batt', 'plots', {'bmbbmbvbvv','bmbbmbvbav','bmbbmbvbtv','bmbbmbvbs','bmbbmbvbf'});
dfs.plot('bmbbmbvbvv','label','Volts 28V1','vars',{'B3MB_28V1_Batt1_V','B3MB_28V1_Batt2_V','B3MB_28V1_Batt3_V','B3MB_28V1_Batt4_V','B3MB_28V1_Bus_V'});
dfs.plot('bmbbmbvbav','label','Amps 28V1','vars',{'B3MB_28V1_Batt1_I','B3MB_28V1_Batt2_I','B3MB_28V1_Batt3_I','B3MB_28V1_Batt4_I'});
dfs.plot('bmbbmbvbtv','label','Temp 28V1','vars',{'B3MB_28V1_T1','B3MB_28V1_T2','B3MB_28V1_T3','B3MB_28V1_T4','B3MB_28V1_T5'});
dfs.plot('bmbbmbvbs','label','Status','vars',{{'name','B3MB_28V1_B1S','var_name','B3MB_28V1_Cmd_S','bit_number',0},{'name','B3MB_28V1_B2S','var_name','B3MB_28V1_Cmd_S','bit_number',1},{'name','B3MB_28V1_B3S','var_name','B3MB_28V1_Cmd_S','bit_number',2},{'name','B3MB_28V1_B4S','var_name','B3MB_28V1_Cmd_S','bit_number',3},{'name','B3MB_28V1_Stat_LED','var_name','B3MB_28V1_LED_S','bit_number',0},{'name','B3MB_28V1_Fault_LED','var_name','B3MB_28V1_LED_S','bit_number',1},{'name','B3MB_28V1_ID_CPU','var_name','B3MB_28V1_LED_S','bit_number',2}});
dfs.plot('bmbbmbvbf','label','Fault','vars',{{'name','B3MB_28V1_B1F','var_name','B3MB_28V1_Cmd_S','bit_number',8},{'name','B3MB_28V1_B2F','var_name','B3MB_28V1_Cmd_S','bit_number',9},{'name','B3MB_28V1_B3F','var_name','B3MB_28V1_Cmd_S','bit_number',10},{'name','B3MB_28V1_B4F','var_name','B3MB_28V1_Cmd_S','bit_number',11}});
dfs.plot('bmbbmbvl', 'label', 'B3MB 28V1 Load', 'plots', {'bmbbmbvlvv','bmbbmbvlav','bmbbmbvls','bmbbmbvlf'});
dfs.plot('bmbbmbvlvv','label','Volts 28V1','vars',{'B3MB_28V1_Load1_V','B3MB_28V1_Load2_V','B3MB_28V1_Load3_V','B3MB_28V1_Load4_V'});
dfs.plot('bmbbmbvlav','label','Amps 28V1','vars',{'B3MB_28V1_Load1_I','B3MB_28V1_Load2_I','B3MB_28V1_Load3_I','B3MB_28V1_Load4_I'});
dfs.plot('bmbbmbvls','label','Status','vars',{{'name','B3MB_28V1_Load1S','var_name','B3MB_28V1_Cmd_S','bit_number',4},{'name','B3MB_28V1_Load2S','var_name','B3MB_28V1_Cmd_S','bit_number',5},{'name','B3MB_28V1_Load3S','var_name','B3MB_28V1_Cmd_S','bit_number',6},{'name','B3MB_28V1_Load4S','var_name','B3MB_28V1_Cmd_S','bit_number',7}});
dfs.plot('bmbbmbvlf','label','Fault','vars',{{'name','B3MB_28V1_Load1F','var_name','B3MB_28V1_Cmd_S','bit_number',12},{'name','B3MB_28V1_Load2F','var_name','B3MB_28V1_Cmd_S','bit_number',13},{'name','B3MB_28V1_Load3F','var_name','B3MB_28V1_Cmd_S','bit_number',14},{'name','B3MB_28V1_Load4F','var_name','B3MB_28V1_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_28v2_batt', 'label', 'B3MB 28V2 Batt', 'plots', {'b3mb_b3mb_28v2_battvv','b3mb_b3mb_28v2_battav','b3mb_b3mb_28v2_batttv','b3mb_b3mb_28v2_batts','b3mb_b3mb_28v2_battf'});
dfs.plot('b3mb_b3mb_28v2_battvv','label','Volts 28V2','vars',{'B3MB_28V2_Batt1_V','B3MB_28V2_Batt2_V','B3MB_28V2_Batt3_V','B3MB_28V2_Batt4_V','B3MB_28V2_Bus_V'});
dfs.plot('b3mb_b3mb_28v2_battav','label','Amps 28V2','vars',{'B3MB_28V2_Batt1_I','B3MB_28V2_Batt2_I','B3MB_28V2_Batt3_I','B3MB_28V2_Batt4_I'});
dfs.plot('b3mb_b3mb_28v2_batttv','label','Temp 28V2','vars',{'B3MB_28V2_T1','B3MB_28V2_T2','B3MB_28V2_T3','B3MB_28V2_T4','B3MB_28V2_T5'});
dfs.plot('b3mb_b3mb_28v2_batts','label','Status','vars',{{'name','B3MB_28V2_B1S','var_name','B3MB_28V2_Cmd_S','bit_number',0},{'name','B3MB_28V2_B2S','var_name','B3MB_28V2_Cmd_S','bit_number',1},{'name','B3MB_28V2_B3S','var_name','B3MB_28V2_Cmd_S','bit_number',2},{'name','B3MB_28V2_B4S','var_name','B3MB_28V2_Cmd_S','bit_number',3},{'name','B3MB_28V2_Stat_LED','var_name','B3MB_28V2_LED_S','bit_number',0},{'name','B3MB_28V2_Fault_LED','var_name','B3MB_28V2_LED_S','bit_number',1},{'name','B3MB_28V2_ID_CPU','var_name','B3MB_28V2_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_28v2_battf','label','Fault','vars',{{'name','B3MB_28V2_B1F','var_name','B3MB_28V2_Cmd_S','bit_number',8},{'name','B3MB_28V2_B2F','var_name','B3MB_28V2_Cmd_S','bit_number',9},{'name','B3MB_28V2_B3F','var_name','B3MB_28V2_Cmd_S','bit_number',10},{'name','B3MB_28V2_B4F','var_name','B3MB_28V2_Cmd_S','bit_number',11}});
dfs.plot('b3mb_b3mb_28v2_load', 'label', 'B3MB 28V2 Load', 'plots', {'b3mb_b3mb_28v2_loadvv','b3mb_b3mb_28v2_loadav','b3mb_b3mb_28v2_loads','b3mb_b3mb_28v2_loadf'});
dfs.plot('b3mb_b3mb_28v2_loadvv','label','Volts 28V2','vars',{'B3MB_28V2_Load1_V','B3MB_28V2_Load2_V','B3MB_28V2_Load3_V','B3MB_28V2_Load4_V'});
dfs.plot('b3mb_b3mb_28v2_loadav','label','Amps 28V2','vars',{'B3MB_28V2_Load1_I','B3MB_28V2_Load2_I','B3MB_28V2_Load3_I','B3MB_28V2_Load4_I'});
dfs.plot('b3mb_b3mb_28v2_loads','label','Status','vars',{{'name','B3MB_28V2_Load1S','var_name','B3MB_28V2_Cmd_S','bit_number',4},{'name','B3MB_28V2_Load2S','var_name','B3MB_28V2_Cmd_S','bit_number',5},{'name','B3MB_28V2_Load3S','var_name','B3MB_28V2_Cmd_S','bit_number',6},{'name','B3MB_28V2_Load4S','var_name','B3MB_28V2_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_28v2_loadf','label','Fault','vars',{{'name','B3MB_28V2_Load1F','var_name','B3MB_28V2_Cmd_S','bit_number',12},{'name','B3MB_28V2_Load2F','var_name','B3MB_28V2_Cmd_S','bit_number',13},{'name','B3MB_28V2_Load3F','var_name','B3MB_28V2_Cmd_S','bit_number',14},{'name','B3MB_28V2_Load4F','var_name','B3MB_28V2_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v1_batt', 'label', 'B3MB 100V1 Batt', 'plots', {'b3mb_b3mb_100v1_battvv','b3mb_b3mb_100v1_battav','b3mb_b3mb_100v1_batttv','b3mb_b3mb_100v1_batts','b3mb_b3mb_100v1_battf'});
dfs.plot('b3mb_b3mb_100v1_battvv','label','Volts 100V1','vars',{'B3MB_100V1_Batt1_V','B3MB_100V1_Bus_V'});
dfs.plot('b3mb_b3mb_100v1_battav','label','Amps 100V1','vars',{'B3MB_100V1_Batt1_I'});
dfs.plot('b3mb_b3mb_100v1_batttv','label','Temp 100V1','vars',{'B3MB_100V1_T1','B3MB_100V1_T2','B3MB_100V1_T3','B3MB_100V1_T4','B3MB_100V1_T5'});
dfs.plot('b3mb_b3mb_100v1_batts','label','Status','vars',{{'name','B3MB_100V1_B1S','var_name','B3MB_100V1_Cmd_S','bit_number',0},{'name','B3MB_100V1_Stat_LED','var_name','B3MB_100V1_LED_S','bit_number',0},{'name','B3MB_100V1_Fault_LED','var_name','B3MB_100V1_LED_S','bit_number',1},{'name','B3MB_100V1_ID_CPU','var_name','B3MB_100V1_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v1_battf','label','Fault','vars',{{'name','B3MB_100V1_B1F','var_name','B3MB_100V1_Cmd_S','bit_number',8}});
dfs.plot('b3mb_b3mb_100v1_load', 'label', 'B3MB 100V1 Load', 'plots', {'b3mb_b3mb_100v1_loadvv','b3mb_b3mb_100v1_loadav','b3mb_b3mb_100v1_loads','b3mb_b3mb_100v1_loadf'});
dfs.plot('b3mb_b3mb_100v1_loadvv','label','Volts 100V1','vars',{'B3MB_100V1_Load1_V','B3MB_100V1_Load2_V','B3MB_100V1_Load3_V','B3MB_100V1_Load4_V'});
dfs.plot('b3mb_b3mb_100v1_loadav','label','Amps 100V1','vars',{'B3MB_100V1_Load1_I','B3MB_100V1_Load2_I','B3MB_100V1_Load3_I','B3MB_100V1_Load4_I'});
dfs.plot('b3mb_b3mb_100v1_loads','label','Status','vars',{{'name','B3MB_100V1_Load1S','var_name','B3MB_100V1_Cmd_S','bit_number',4},{'name','B3MB_100V1_Load2S','var_name','B3MB_100V1_Cmd_S','bit_number',5},{'name','B3MB_100V1_Load3S','var_name','B3MB_100V1_Cmd_S','bit_number',6},{'name','B3MB_100V1_Load4S','var_name','B3MB_100V1_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v1_loadf','label','Fault','vars',{{'name','B3MB_100V1_Load1F','var_name','B3MB_100V1_Cmd_S','bit_number',12},{'name','B3MB_100V1_Load2F','var_name','B3MB_100V1_Cmd_S','bit_number',13},{'name','B3MB_100V1_Load3F','var_name','B3MB_100V1_Cmd_S','bit_number',14},{'name','B3MB_100V1_Load4F','var_name','B3MB_100V1_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v2_batt', 'label', 'B3MB 100V2 Batt', 'plots', {'b3mb_b3mb_100v2_battvv','b3mb_b3mb_100v2_battav','b3mb_b3mb_100v2_batttv','b3mb_b3mb_100v2_batts','b3mb_b3mb_100v2_battf'});
dfs.plot('b3mb_b3mb_100v2_battvv','label','Volts 100V2','vars',{'B3MB_100V2_Batt1_V','B3MB_100V2_Bus_V'});
dfs.plot('b3mb_b3mb_100v2_battav','label','Amps 100V2','vars',{'B3MB_100V2_Batt1_I'});
dfs.plot('b3mb_b3mb_100v2_batttv','label','Temp 100V2','vars',{'B3MB_100V2_T1','B3MB_100V2_T2','B3MB_100V2_T3','B3MB_100V2_T4','B3MB_100V2_T5'});
dfs.plot('b3mb_b3mb_100v2_batts','label','Status','vars',{{'name','B3MB_100V2_B1S','var_name','B3MB_100V2_Cmd_S','bit_number',0},{'name','B3MB_100V2_Stat_LED','var_name','B3MB_100V2_LED_S','bit_number',0},{'name','B3MB_100V2_Fault_LED','var_name','B3MB_100V2_LED_S','bit_number',1},{'name','B3MB_100V2_ID_CPU','var_name','B3MB_100V2_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v2_battf','label','Fault','vars',{{'name','B3MB_100V2_B1F','var_name','B3MB_100V2_Cmd_S','bit_number',8}});
dfs.plot('b3mb_b3mb_100v2_load', 'label', 'B3MB 100V2 Load', 'plots', {'b3mb_b3mb_100v2_loadvv','b3mb_b3mb_100v2_loadav','b3mb_b3mb_100v2_loads','b3mb_b3mb_100v2_loadf'});
dfs.plot('b3mb_b3mb_100v2_loadvv','label','Volts 100V2','vars',{'B3MB_100V2_Load1_V','B3MB_100V2_Load2_V','B3MB_100V2_Load3_V','B3MB_100V2_Load4_V'});
dfs.plot('b3mb_b3mb_100v2_loadav','label','Amps 100V2','vars',{'B3MB_100V2_Load1_I','B3MB_100V2_Load2_I','B3MB_100V2_Load3_I','B3MB_100V2_Load4_I'});
dfs.plot('b3mb_b3mb_100v2_loads','label','Status','vars',{{'name','B3MB_100V2_Load1S','var_name','B3MB_100V2_Cmd_S','bit_number',4},{'name','B3MB_100V2_Load2S','var_name','B3MB_100V2_Cmd_S','bit_number',5},{'name','B3MB_100V2_Load3S','var_name','B3MB_100V2_Cmd_S','bit_number',6},{'name','B3MB_100V2_Load4S','var_name','B3MB_100V2_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v2_loadf','label','Fault','vars',{{'name','B3MB_100V2_Load1F','var_name','B3MB_100V2_Cmd_S','bit_number',12},{'name','B3MB_100V2_Load2F','var_name','B3MB_100V2_Cmd_S','bit_number',13},{'name','B3MB_100V2_Load3F','var_name','B3MB_100V2_Cmd_S','bit_number',14},{'name','B3MB_100V2_Load4F','var_name','B3MB_100V2_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v3_batt', 'label', 'B3MB 100V3 Batt', 'plots', {'b3mb_b3mb_100v3_battvv','b3mb_b3mb_100v3_battav','b3mb_b3mb_100v3_batttv','b3mb_b3mb_100v3_batts','b3mb_b3mb_100v3_battf'});
dfs.plot('b3mb_b3mb_100v3_battvv','label','Volts 100V3','vars',{'B3MB_100V3_Batt1_V','B3MB_100V3_Bus_V'});
dfs.plot('b3mb_b3mb_100v3_battav','label','Amps 100V3','vars',{'B3MB_100V3_Batt1_I'});
dfs.plot('b3mb_b3mb_100v3_batttv','label','Temp 100V3','vars',{'B3MB_100V3_T1','B3MB_100V3_T2','B3MB_100V3_T3','B3MB_100V3_T4','B3MB_100V3_T5'});
dfs.plot('b3mb_b3mb_100v3_batts','label','Status','vars',{{'name','B3MB_100V3_B1S','var_name','B3MB_100V3_Cmd_S','bit_number',0},{'name','B3MB_100V3_Stat_LED','var_name','B3MB_100V3_LED_S','bit_number',0},{'name','B3MB_100V3_Fault_LED','var_name','B3MB_100V3_LED_S','bit_number',1},{'name','B3MB_100V3_ID_CPU','var_name','B3MB_100V3_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v3_battf','label','Fault','vars',{{'name','B3MB_100V3_B1F','var_name','B3MB_100V3_Cmd_S','bit_number',8}});
dfs.plot('b3mb_b3mb_100v3_load', 'label', 'B3MB 100V3 Load', 'plots', {'b3mb_b3mb_100v3_loadvv','b3mb_b3mb_100v3_loadav','b3mb_b3mb_100v3_loads','b3mb_b3mb_100v3_loadf'});
dfs.plot('b3mb_b3mb_100v3_loadvv','label','Volts 100V3','vars',{'B3MB_100V3_Load1_V','B3MB_100V3_Load2_V','B3MB_100V3_Load3_V','B3MB_100V3_Load4_V'});
dfs.plot('b3mb_b3mb_100v3_loadav','label','Amps 100V3','vars',{'B3MB_100V3_Load1_I','B3MB_100V3_Load2_I','B3MB_100V3_Load3_I','B3MB_100V3_Load4_I'});
dfs.plot('b3mb_b3mb_100v3_loads','label','Status','vars',{{'name','B3MB_100V3_Load1S','var_name','B3MB_100V3_Cmd_S','bit_number',4},{'name','B3MB_100V3_Load2S','var_name','B3MB_100V3_Cmd_S','bit_number',5},{'name','B3MB_100V3_Load3S','var_name','B3MB_100V3_Cmd_S','bit_number',6},{'name','B3MB_100V3_Load4S','var_name','B3MB_100V3_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v3_loadf','label','Fault','vars',{{'name','B3MB_100V3_Load1F','var_name','B3MB_100V3_Cmd_S','bit_number',12},{'name','B3MB_100V3_Load2F','var_name','B3MB_100V3_Cmd_S','bit_number',13},{'name','B3MB_100V3_Load3F','var_name','B3MB_100V3_Cmd_S','bit_number',14},{'name','B3MB_100V3_Load4F','var_name','B3MB_100V3_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v4_batt', 'label', 'B3MB 100V4 Batt', 'plots', {'b3mb_b3mb_100v4_battvv','b3mb_b3mb_100v4_battav','b3mb_b3mb_100v4_batttv','b3mb_b3mb_100v4_batts','b3mb_b3mb_100v4_battf'});
dfs.plot('b3mb_b3mb_100v4_battvv','label','Volts 100V4','vars',{'B3MB_100V4_Batt1_V','B3MB_100V4_Bus_V'});
dfs.plot('b3mb_b3mb_100v4_battav','label','Amps 100V4','vars',{'B3MB_100V4_Batt1_I'});
dfs.plot('b3mb_b3mb_100v4_batttv','label','Temp 100V4','vars',{'B3MB_100V4_T1','B3MB_100V4_T2','B3MB_100V4_T3','B3MB_100V4_T4','B3MB_100V4_T5'});
dfs.plot('b3mb_b3mb_100v4_batts','label','Status','vars',{{'name','B3MB_100V4_B1S','var_name','B3MB_100V4_Cmd_S','bit_number',0},{'name','B3MB_100V4_Stat_LED','var_name','B3MB_100V4_LED_S','bit_number',0},{'name','B3MB_100V4_Fault_LED','var_name','B3MB_100V4_LED_S','bit_number',1},{'name','B3MB_100V4_ID_CPU','var_name','B3MB_100V4_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v4_battf','label','Fault','vars',{{'name','B3MB_100V4_B1F','var_name','B3MB_100V4_Cmd_S','bit_number',8}});
dfs.plot('b3mb_b3mb_100v4_load', 'label', 'B3MB 100V4 Load', 'plots', {'b3mb_b3mb_100v4_loadvv','b3mb_b3mb_100v4_loadav','b3mb_b3mb_100v4_loads','b3mb_b3mb_100v4_loadf'});
dfs.plot('b3mb_b3mb_100v4_loadvv','label','Volts 100V4','vars',{'B3MB_100V4_Load1_V','B3MB_100V4_Load2_V','B3MB_100V4_Load3_V','B3MB_100V4_Load4_V'});
dfs.plot('b3mb_b3mb_100v4_loadav','label','Amps 100V4','vars',{'B3MB_100V4_Load1_I','B3MB_100V4_Load2_I','B3MB_100V4_Load3_I','B3MB_100V4_Load4_I'});
dfs.plot('b3mb_b3mb_100v4_loads','label','Status','vars',{{'name','B3MB_100V4_Load1S','var_name','B3MB_100V4_Cmd_S','bit_number',4},{'name','B3MB_100V4_Load2S','var_name','B3MB_100V4_Cmd_S','bit_number',5},{'name','B3MB_100V4_Load3S','var_name','B3MB_100V4_Cmd_S','bit_number',6},{'name','B3MB_100V4_Load4S','var_name','B3MB_100V4_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v4_loadf','label','Fault','vars',{{'name','B3MB_100V4_Load1F','var_name','B3MB_100V4_Cmd_S','bit_number',12},{'name','B3MB_100V4_Load2F','var_name','B3MB_100V4_Cmd_S','bit_number',13},{'name','B3MB_100V4_Load3F','var_name','B3MB_100V4_Cmd_S','bit_number',14},{'name','B3MB_100V4_Load4F','var_name','B3MB_100V4_Cmd_S','bit_number',15}});
dfs.end_tab;
dfs.end_col;
dfs.resize(context_level);
dfs.set_connection('127.0.0.1', 1080);
if nargout > 0
  dfs_out = dfs;
end
