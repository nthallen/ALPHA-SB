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
dfs.end_col;
dfs.start_col;
dfs.plot('pmpsl', 'label', 'MPS Ld', 'plots', {'pmpslv','pmpsla','pmpsls','pmpslstale'});
dfs.plot('pmpslv','label','Volts','vars',{'MPSLd_V_set','MPSLd_V_disp'});
dfs.plot('pmpsla','label','Amps','vars',{'MPSLd_I_set','MPSLd_I_disp'});
dfs.plot('pmpsls','label','Status','vars',{{'name','MPSLd_SS','var_name','MPSLd_Status','bit_number',1},{'name','MPSLd_STBY','var_name','MPSLd_Status','bit_number',6},{'name','MPSLd_PWR','var_name','MPSLd_Status','bit_number',7},{'name','MPSLd_CV','var_name','MPSLd_Status','bit_number',8},{'name','MPSLd_CC','var_name','MPSLd_Status','bit_number',10},{'name','MPSLd_Output','var_name','MPSLd_Status','bit_number',13},{'name','MPSLd_Setpt','var_name','MPSLd_Status','bit_number',14}});
dfs.plot('pmpslstale','label','Stale','vars',{'MPSLd_Stale'});
dfs.end_tab;
dfs.start_tab('B3MB');
dfs.start_col;
dfs.plot('bmbbmbvb', 'label', 'B3MB 28V1 Batt', 'plots', {'bmbbmbvbv','bmbbmbvba','bmbbmbvbt','bmbbmbvbs','bmbbmbvbf'});
dfs.plot('bmbbmbvbv','label','Volts','vars',{'B3MB_28V1_Batt1_V','B3MB_28V1_Batt2_V','B3MB_28V1_Batt3_V','B3MB_28V1_Batt4_V','B3MB_28V1_Bus_V'});
dfs.plot('bmbbmbvba','label','Amps','vars',{'B3MB_28V1_Batt1_I','B3MB_28V1_Batt2_I','B3MB_28V1_Batt3_I','B3MB_28V1_Batt4_I'});
dfs.plot('bmbbmbvbt','label','Temp','vars',{'B3MB_28V1_T1','B3MB_28V1_T2','B3MB_28V1_T3','B3MB_28V1_T4','B3MB_28V1_T5'});
dfs.plot('bmbbmbvbs','label','Status','vars',{{'name','B3MB_28V1_B1S','var_name','B3MB_28V1_Cmd_S','bit_number',0},{'name','B3MB_28V1_B2S','var_name','B3MB_28V1_Cmd_S','bit_number',1},{'name','B3MB_28V1_B3S','var_name','B3MB_28V1_Cmd_S','bit_number',2},{'name','B3MB_28V1_B4S','var_name','B3MB_28V1_Cmd_S','bit_number',3},{'name','B3MB_28V1_Stat_LED','var_name','B3MB_28V1_LED_S','bit_number',0},{'name','B3MB_28V1_Fault_LED','var_name','B3MB_28V1_LED_S','bit_number',1},{'name','B3MB_28V1_ID_CPU','var_name','B3MB_28V1_LED_S','bit_number',2}});
dfs.plot('bmbbmbvbf','label','Fault','vars',{{'name','B3MB_28V1_B1F','var_name','B3MB_28V1_Cmd_S','bit_number',8},{'name','B3MB_28V1_B2F','var_name','B3MB_28V1_Cmd_S','bit_number',9},{'name','B3MB_28V1_B3F','var_name','B3MB_28V1_Cmd_S','bit_number',10},{'name','B3MB_28V1_B4F','var_name','B3MB_28V1_Cmd_S','bit_number',11}});
dfs.plot('bmbbmbvl', 'label', 'B3MB 28V1 Load', 'plots', {'bmbbmbvlv','bmbbmbvla','bmbbmbvls','bmbbmbvlf'});
dfs.plot('bmbbmbvlv','label','Volts','vars',{'B3MB_28V1_Load1_V','B3MB_28V1_Load2_V','B3MB_28V1_Load3_V','B3MB_28V1_Load4_V'});
dfs.plot('bmbbmbvla','label','Amps','vars',{'B3MB_28V1_Load1_I','B3MB_28V1_Load2_I','B3MB_28V1_Load3_I','B3MB_28V1_Load4_I'});
dfs.plot('bmbbmbvls','label','Status','vars',{{'name','B3MB_28V1_L1S','var_name','B3MB_28V1_Cmd_S','bit_number',4},{'name','B3MB_28V1_L2S','var_name','B3MB_28V1_Cmd_S','bit_number',5},{'name','B3MB_28V1_L3S','var_name','B3MB_28V1_Cmd_S','bit_number',6},{'name','B3MB_28V1_L4S','var_name','B3MB_28V1_Cmd_S','bit_number',7}});
dfs.plot('bmbbmbvlf','label','Fault','vars',{{'name','B3MB_28V1_L1F','var_name','B3MB_28V1_Cmd_S','bit_number',12},{'name','B3MB_28V1_L2F','var_name','B3MB_28V1_Cmd_S','bit_number',13},{'name','B3MB_28V1_L3F','var_name','B3MB_28V1_Cmd_S','bit_number',14},{'name','B3MB_28V1_L4F','var_name','B3MB_28V1_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v1_batt', 'label', 'B3MB 100V1 Batt', 'plots', {'b3mb_b3mb_100v1_battv','b3mb_b3mb_100v1_batta','b3mb_b3mb_100v1_battt','b3mb_b3mb_100v1_batts','b3mb_b3mb_100v1_battf'});
dfs.plot('b3mb_b3mb_100v1_battv','label','Volts','vars',{'B3MB_100V1_Batt1_V','B3MB_100V1_Batt2_V','B3MB_100V1_Batt3_V','B3MB_100V1_Batt4_V','B3MB_100V1_Bus_V'});
dfs.plot('b3mb_b3mb_100v1_batta','label','Amps','vars',{'B3MB_100V1_Batt1_I','B3MB_100V1_Batt2_I','B3MB_100V1_Batt3_I','B3MB_100V1_Batt4_I'});
dfs.plot('b3mb_b3mb_100v1_battt','label','Temp','vars',{'B3MB_100V1_T1','B3MB_100V1_T2','B3MB_100V1_T3','B3MB_100V1_T4','B3MB_100V1_T5'});
dfs.plot('b3mb_b3mb_100v1_batts','label','Status','vars',{{'name','B3MB_100V1_B1S','var_name','B3MB_100V1_Cmd_S','bit_number',0},{'name','B3MB_100V1_B2S','var_name','B3MB_100V1_Cmd_S','bit_number',1},{'name','B3MB_100V1_B3S','var_name','B3MB_100V1_Cmd_S','bit_number',2},{'name','B3MB_100V1_B4S','var_name','B3MB_100V1_Cmd_S','bit_number',3},{'name','B3MB_100V1_Stat_LED','var_name','B3MB_100V1_LED_S','bit_number',0},{'name','B3MB_100V1_Fault_LED','var_name','B3MB_100V1_LED_S','bit_number',1},{'name','B3MB_100V1_ID_CPU','var_name','B3MB_100V1_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v1_battf','label','Fault','vars',{{'name','B3MB_100V1_B1F','var_name','B3MB_100V1_Cmd_S','bit_number',8},{'name','B3MB_100V1_B2F','var_name','B3MB_100V1_Cmd_S','bit_number',9},{'name','B3MB_100V1_B3F','var_name','B3MB_100V1_Cmd_S','bit_number',10},{'name','B3MB_100V1_B4F','var_name','B3MB_100V1_Cmd_S','bit_number',11}});
dfs.plot('b3mb_b3mb_100v1_load', 'label', 'B3MB 100V1 Load', 'plots', {'b3mb_b3mb_100v1_loadv','b3mb_b3mb_100v1_loada','b3mb_b3mb_100v1_loads','b3mb_b3mb_100v1_loadf'});
dfs.plot('b3mb_b3mb_100v1_loadv','label','Volts','vars',{'B3MB_100V1_Load1_V','B3MB_100V1_Load2_V','B3MB_100V1_Load3_V','B3MB_100V1_Load4_V'});
dfs.plot('b3mb_b3mb_100v1_loada','label','Amps','vars',{'B3MB_100V1_Load1_I','B3MB_100V1_Load2_I','B3MB_100V1_Load3_I','B3MB_100V1_Load4_I'});
dfs.plot('b3mb_b3mb_100v1_loads','label','Status','vars',{{'name','B3MB_100V1_L1S','var_name','B3MB_100V1_Cmd_S','bit_number',4},{'name','B3MB_100V1_L2S','var_name','B3MB_100V1_Cmd_S','bit_number',5},{'name','B3MB_100V1_L3S','var_name','B3MB_100V1_Cmd_S','bit_number',6},{'name','B3MB_100V1_L4S','var_name','B3MB_100V1_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v1_loadf','label','Fault','vars',{{'name','B3MB_100V1_L1F','var_name','B3MB_100V1_Cmd_S','bit_number',12},{'name','B3MB_100V1_L2F','var_name','B3MB_100V1_Cmd_S','bit_number',13},{'name','B3MB_100V1_L3F','var_name','B3MB_100V1_Cmd_S','bit_number',14},{'name','B3MB_100V1_L4F','var_name','B3MB_100V1_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v2_batt', 'label', 'B3MB 100V2 Batt', 'plots', {'b3mb_b3mb_100v2_battv','b3mb_b3mb_100v2_batta','b3mb_b3mb_100v2_battt','b3mb_b3mb_100v2_batts','b3mb_b3mb_100v2_battf'});
dfs.plot('b3mb_b3mb_100v2_battv','label','Volts','vars',{'B3MB_100V2_Batt1_V','B3MB_100V2_Batt2_V','B3MB_100V2_Batt3_V','B3MB_100V2_Batt4_V','B3MB_100V2_Bus_V'});
dfs.plot('b3mb_b3mb_100v2_batta','label','Amps','vars',{'B3MB_100V2_Batt1_I','B3MB_100V2_Batt2_I','B3MB_100V2_Batt3_I','B3MB_100V2_Batt4_I'});
dfs.plot('b3mb_b3mb_100v2_battt','label','Temp','vars',{'B3MB_100V2_T1','B3MB_100V2_T2','B3MB_100V2_T3','B3MB_100V2_T4','B3MB_100V2_T5'});
dfs.plot('b3mb_b3mb_100v2_batts','label','Status','vars',{{'name','B3MB_100V2_B1S','var_name','B3MB_100V2_Cmd_S','bit_number',0},{'name','B3MB_100V2_B2S','var_name','B3MB_100V2_Cmd_S','bit_number',1},{'name','B3MB_100V2_B3S','var_name','B3MB_100V2_Cmd_S','bit_number',2},{'name','B3MB_100V2_B4S','var_name','B3MB_100V2_Cmd_S','bit_number',3},{'name','B3MB_100V2_Stat_LED','var_name','B3MB_100V2_LED_S','bit_number',0},{'name','B3MB_100V2_Fault_LED','var_name','B3MB_100V2_LED_S','bit_number',1},{'name','B3MB_100V2_ID_CPU','var_name','B3MB_100V2_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v2_battf','label','Fault','vars',{{'name','B3MB_100V2_B1F','var_name','B3MB_100V2_Cmd_S','bit_number',8},{'name','B3MB_100V2_B2F','var_name','B3MB_100V2_Cmd_S','bit_number',9},{'name','B3MB_100V2_B3F','var_name','B3MB_100V2_Cmd_S','bit_number',10},{'name','B3MB_100V2_B4F','var_name','B3MB_100V2_Cmd_S','bit_number',11}});
dfs.plot('b3mb_b3mb_100v2_load', 'label', 'B3MB 100V2 Load', 'plots', {'b3mb_b3mb_100v2_loadv','b3mb_b3mb_100v2_loada','b3mb_b3mb_100v2_loads','b3mb_b3mb_100v2_loadf'});
dfs.plot('b3mb_b3mb_100v2_loadv','label','Volts','vars',{'B3MB_100V2_Load1_V','B3MB_100V2_Load2_V','B3MB_100V2_Load3_V','B3MB_100V2_Load4_V'});
dfs.plot('b3mb_b3mb_100v2_loada','label','Amps','vars',{'B3MB_100V2_Load1_I','B3MB_100V2_Load2_I','B3MB_100V2_Load3_I','B3MB_100V2_Load4_I'});
dfs.plot('b3mb_b3mb_100v2_loads','label','Status','vars',{{'name','B3MB_100V2_L1S','var_name','B3MB_100V2_Cmd_S','bit_number',4},{'name','B3MB_100V2_L2S','var_name','B3MB_100V2_Cmd_S','bit_number',5},{'name','B3MB_100V2_L3S','var_name','B3MB_100V2_Cmd_S','bit_number',6},{'name','B3MB_100V2_L4S','var_name','B3MB_100V2_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v2_loadf','label','Fault','vars',{{'name','B3MB_100V2_L1F','var_name','B3MB_100V2_Cmd_S','bit_number',12},{'name','B3MB_100V2_L2F','var_name','B3MB_100V2_Cmd_S','bit_number',13},{'name','B3MB_100V2_L3F','var_name','B3MB_100V2_Cmd_S','bit_number',14},{'name','B3MB_100V2_L4F','var_name','B3MB_100V2_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v3_batt', 'label', 'B3MB 100V3 Batt', 'plots', {'b3mb_b3mb_100v3_battv','b3mb_b3mb_100v3_batta','b3mb_b3mb_100v3_battt','b3mb_b3mb_100v3_batts','b3mb_b3mb_100v3_battf'});
dfs.plot('b3mb_b3mb_100v3_battv','label','Volts','vars',{'B3MB_100V3_Batt1_V','B3MB_100V3_Batt2_V','B3MB_100V3_Batt3_V','B3MB_100V3_Batt4_V','B3MB_100V3_Bus_V'});
dfs.plot('b3mb_b3mb_100v3_batta','label','Amps','vars',{'B3MB_100V3_Batt1_I','B3MB_100V3_Batt2_I','B3MB_100V3_Batt3_I','B3MB_100V3_Batt4_I'});
dfs.plot('b3mb_b3mb_100v3_battt','label','Temp','vars',{'B3MB_100V3_T1','B3MB_100V3_T2','B3MB_100V3_T3','B3MB_100V3_T4','B3MB_100V3_T5'});
dfs.plot('b3mb_b3mb_100v3_batts','label','Status','vars',{{'name','B3MB_100V3_B1S','var_name','B3MB_100V3_Cmd_S','bit_number',0},{'name','B3MB_100V3_B2S','var_name','B3MB_100V3_Cmd_S','bit_number',1},{'name','B3MB_100V3_B3S','var_name','B3MB_100V3_Cmd_S','bit_number',2},{'name','B3MB_100V3_B4S','var_name','B3MB_100V3_Cmd_S','bit_number',3},{'name','B3MB_100V3_Stat_LED','var_name','B3MB_100V3_LED_S','bit_number',0},{'name','B3MB_100V3_Fault_LED','var_name','B3MB_100V3_LED_S','bit_number',1},{'name','B3MB_100V3_ID_CPU','var_name','B3MB_100V3_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v3_battf','label','Fault','vars',{{'name','B3MB_100V3_B1F','var_name','B3MB_100V3_Cmd_S','bit_number',8},{'name','B3MB_100V3_B2F','var_name','B3MB_100V3_Cmd_S','bit_number',9},{'name','B3MB_100V3_B3F','var_name','B3MB_100V3_Cmd_S','bit_number',10},{'name','B3MB_100V3_B4F','var_name','B3MB_100V3_Cmd_S','bit_number',11}});
dfs.plot('b3mb_b3mb_100v3_load', 'label', 'B3MB 100V3 Load', 'plots', {'b3mb_b3mb_100v3_loadv','b3mb_b3mb_100v3_loada','b3mb_b3mb_100v3_loads','b3mb_b3mb_100v3_loadf'});
dfs.plot('b3mb_b3mb_100v3_loadv','label','Volts','vars',{'B3MB_100V3_Load1_V','B3MB_100V3_Load2_V','B3MB_100V3_Load3_V','B3MB_100V3_Load4_V'});
dfs.plot('b3mb_b3mb_100v3_loada','label','Amps','vars',{'B3MB_100V3_Load1_I','B3MB_100V3_Load2_I','B3MB_100V3_Load3_I','B3MB_100V3_Load4_I'});
dfs.plot('b3mb_b3mb_100v3_loads','label','Status','vars',{{'name','B3MB_100V3_L1S','var_name','B3MB_100V3_Cmd_S','bit_number',4},{'name','B3MB_100V3_L2S','var_name','B3MB_100V3_Cmd_S','bit_number',5},{'name','B3MB_100V3_L3S','var_name','B3MB_100V3_Cmd_S','bit_number',6},{'name','B3MB_100V3_L4S','var_name','B3MB_100V3_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v3_loadf','label','Fault','vars',{{'name','B3MB_100V3_L1F','var_name','B3MB_100V3_Cmd_S','bit_number',12},{'name','B3MB_100V3_L2F','var_name','B3MB_100V3_Cmd_S','bit_number',13},{'name','B3MB_100V3_L3F','var_name','B3MB_100V3_Cmd_S','bit_number',14},{'name','B3MB_100V3_L4F','var_name','B3MB_100V3_Cmd_S','bit_number',15}});
dfs.end_col;
dfs.start_col;
dfs.plot('b3mb_b3mb_100v4_batt', 'label', 'B3MB 100V4 Batt', 'plots', {'b3mb_b3mb_100v4_battv','b3mb_b3mb_100v4_batta','b3mb_b3mb_100v4_battt','b3mb_b3mb_100v4_batts','b3mb_b3mb_100v4_battf'});
dfs.plot('b3mb_b3mb_100v4_battv','label','Volts','vars',{'B3MB_100V4_Batt1_V','B3MB_100V4_Batt2_V','B3MB_100V4_Batt3_V','B3MB_100V4_Batt4_V','B3MB_100V4_Bus_V'});
dfs.plot('b3mb_b3mb_100v4_batta','label','Amps','vars',{'B3MB_100V4_Batt1_I','B3MB_100V4_Batt2_I','B3MB_100V4_Batt3_I','B3MB_100V4_Batt4_I'});
dfs.plot('b3mb_b3mb_100v4_battt','label','Temp','vars',{'B3MB_100V4_T1','B3MB_100V4_T2','B3MB_100V4_T3','B3MB_100V4_T4','B3MB_100V4_T5'});
dfs.plot('b3mb_b3mb_100v4_batts','label','Status','vars',{{'name','B3MB_100V4_B1S','var_name','B3MB_100V4_Cmd_S','bit_number',0},{'name','B3MB_100V4_B2S','var_name','B3MB_100V4_Cmd_S','bit_number',1},{'name','B3MB_100V4_B3S','var_name','B3MB_100V4_Cmd_S','bit_number',2},{'name','B3MB_100V4_B4S','var_name','B3MB_100V4_Cmd_S','bit_number',3},{'name','B3MB_100V4_Stat_LED','var_name','B3MB_100V4_LED_S','bit_number',0},{'name','B3MB_100V4_Fault_LED','var_name','B3MB_100V4_LED_S','bit_number',1},{'name','B3MB_100V4_ID_CPU','var_name','B3MB_100V4_LED_S','bit_number',2}});
dfs.plot('b3mb_b3mb_100v4_battf','label','Fault','vars',{{'name','B3MB_100V4_B1F','var_name','B3MB_100V4_Cmd_S','bit_number',8},{'name','B3MB_100V4_B2F','var_name','B3MB_100V4_Cmd_S','bit_number',9},{'name','B3MB_100V4_B3F','var_name','B3MB_100V4_Cmd_S','bit_number',10},{'name','B3MB_100V4_B4F','var_name','B3MB_100V4_Cmd_S','bit_number',11}});
dfs.plot('b3mb_b3mb_100v4_load', 'label', 'B3MB 100V4 Load', 'plots', {'b3mb_b3mb_100v4_loadv','b3mb_b3mb_100v4_loada','b3mb_b3mb_100v4_loads','b3mb_b3mb_100v4_loadf'});
dfs.plot('b3mb_b3mb_100v4_loadv','label','Volts','vars',{'B3MB_100V4_Load1_V','B3MB_100V4_Load2_V','B3MB_100V4_Load3_V','B3MB_100V4_Load4_V'});
dfs.plot('b3mb_b3mb_100v4_loada','label','Amps','vars',{'B3MB_100V4_Load1_I','B3MB_100V4_Load2_I','B3MB_100V4_Load3_I','B3MB_100V4_Load4_I'});
dfs.plot('b3mb_b3mb_100v4_loads','label','Status','vars',{{'name','B3MB_100V4_L1S','var_name','B3MB_100V4_Cmd_S','bit_number',4},{'name','B3MB_100V4_L2S','var_name','B3MB_100V4_Cmd_S','bit_number',5},{'name','B3MB_100V4_L3S','var_name','B3MB_100V4_Cmd_S','bit_number',6},{'name','B3MB_100V4_L4S','var_name','B3MB_100V4_Cmd_S','bit_number',7}});
dfs.plot('b3mb_b3mb_100v4_loadf','label','Fault','vars',{{'name','B3MB_100V4_L1F','var_name','B3MB_100V4_Cmd_S','bit_number',12},{'name','B3MB_100V4_L2F','var_name','B3MB_100V4_Cmd_S','bit_number',13},{'name','B3MB_100V4_L3F','var_name','B3MB_100V4_Cmd_S','bit_number',14},{'name','B3MB_100V4_L4F','var_name','B3MB_100V4_Cmd_S','bit_number',15}});
dfs.end_tab;
dfs.end_col;
dfs.resize(context_level);
dfs.set_connection('127.0.0.1', 1080);
if nargout > 0
  dfs_out = dfs;
end
