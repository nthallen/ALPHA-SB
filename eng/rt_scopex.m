% rt_scopex.m script
dfs = data_fields('h_leading', 5, 'txt_fontsize', 12, 'title', 'SCoPEx Platform');
dfs.start_col;
dfs.data_plot('s', 'label', 'System', 'plots', {'ssws'});
dfs.data_plot('ssws','label','SW Stat','vars',{'SWStat'});
dfs.data_plot('tm', 'label', 'T Mbase', 'plots', {'tmtd','tmcpu','tmram','tmd'});
dfs.data_plot('tmtd','label','T Drift','vars',{'SysTDrift'});
dfs.data_plot('tmcpu','label','CPU','vars',{'CPU_Pct'});
dfs.data_plot('tmram','label','RAM','vars',{'memused'});
dfs.data_plot('tmd','label','Disk','vars',{'Disk'});
dfs.data_plot('pmc', 'label', 'PMC', 'plots', {'pmcs'});
dfs.data_plot('pmcs','label','Stale','vars',{'PMC_Stale','PMC_StaleF'});
dfs.data_plot('pmcl', 'label', 'PMC Left', 'plots', {'pmclrpm','pmclc','pmclv','pmclp'});
dfs.data_plot('pmclrpm','label','RPM','vars',{'PMC_Left_RPM_SP','PMC_Left_RPM_Demand','PMC_Left_RPM'});
dfs.data_plot('pmclc','label','Current','vars',{'PMC_Left_I_Demand','PMC_Left_I_Measured'});
dfs.data_plot('pmclv','label','Voltage','vars',{'PMC_Left_BusV'});
dfs.data_plot('pmclp','label','Position','vars',{'PMC_Left_Pos_SP','PMC_Left_Pos_Demand','PMC_Left_Pos_Target','PMC_Left_Pos_Measured'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('pmcls', 'label', 'PMC Left S', 'plots', {'pmclss','pmclsstatus1','pmclsstatus2','pmclsstatus3','pmclsstatus4','pmclsstatus5','pmclsstatus6'});
dfs.data_plot('pmclss','label','Status 0','vars',{'Bridge_En:PMC_Left_Status0:0','DynBrk_En:PMC_Left_Status0:1','Stop_En:PMC_Left_Status0:2','PosStop_En:PMC_Left_Status0:3','NegStop_En:PMC_Left_Status0:4','PosTrqInh_In:PMC_Left_Status0:5','NegTrqInh_En:PMC_Left_Status0:6','ExtBrk_En:PMC_Left_Status0:7'});
dfs.data_plot('pmclsstatus1','label','Status 1','vars',{'DrvReset:PMC_Left_Status1:0','DrvIntErr:PMC_Left_Status1:1','ShortCir:PMC_Left_Status1:2','CurOverShoot:PMC_Left_Status1:3','DrvUnderV:PMC_Left_Status1:4','DrvOverV:PMC_Left_Status1:5','DrvOverT:PMC_Left_Status1:6'});
dfs.data_plot('pmclsstatus2','label','Status 2','vars',{'ParRestoreErr:PMC_Left_Status2:0','ParStoreErr:PMC_Left_Status2:1','InvHallState:PMC_Left_Status2:2','PhaseSyncErr:PMC_Left_Status2:3','MotorOverT:PMC_Left_Status2:4','PhaseDetFault:PMC_Left_Status2:5','FBSensorErr:PMC_Left_Status2:6','MotorOverSpeed:PMC_Left_Status2:7','MaxMeasuredPos:PMC_Left_Status2:8','MinMeasuredPos:PMC_Left_Status2:9','CommError:PMC_Left_Status2:10','PWMBrokenWire:PMC_Left_Status2:11','MotionEngErr:PMC_Left_Status2:12','MotionEngAbrt:PMC_Left_Status2:13'});
dfs.data_plot('pmclsstatus3','label','Status 3','vars',{'LogEntryMissed:PMC_Left_Status3:0','SWDisable:PMC_Left_Status3:1','UserDisable:PMC_Left_Status3:2','UserPosInh:PMC_Left_Status3:3','UserNegInh:PMC_Left_Status3:4','CurLimiting:PMC_Left_Status3:5','ContCurFoldback:PMC_Left_Status3:6','CurLoopSat:PMC_Left_Status3:7','UserUnderV:PMC_Left_Status3:8','UserOverV:PMC_Left_Status3:9','NonSinComm:PMC_Left_Status3:10','PhaseDetectActive:PMC_Left_Status3:11','MotionEngActive:PMC_Left_Status3:12','UserAuxDisable:PMC_Left_Status3:13','ShuntRegActive:PMC_Left_Status3:14','PhaseDetectDone:PMC_Left_Status3:15'});
dfs.data_plot('pmclsstatus4','label','Status 4','vars',{'ZeroVel:PMC_Left_Status4:0','AtCommand:PMC_Left_Status4:1','VelFollErr:PMC_Left_Status4:2','PosTargVelLim:PMC_Left_Status4:3','NegTargVelLim:PMC_Left_Status4:4','CmdLimiterAct:PMC_Left_Status4:5','InHomPos:PMC_Left_Status4:6','PosFollErr:PMC_Left_Status4:7','MaxTargPosLim:PMC_Left_Status4:8','MinTargPosLim:PMC_Left_Status4:9','SetPosActive:PMC_Left_Status4:10','HomingActive:PMC_Left_Status4:12','SafeTrqOff:PMC_Left_Status4:13','HomingDone:PMC_Left_Status4:14','ZeroPos:PMC_Left_Status4:15'});
dfs.data_plot('pmclsstatus5','label','Status 5','vars',{'CmddStop:PMC_Left_Status5:6','UserStop:PMC_Left_Status5:7','Cap1Active:PMC_Left_Status5:8','Cap2Active:PMC_Left_Status5:9','Cap3Active:PMC_Left_Status5:10','CmddPosLim:PMC_Left_Status5:11','CmddNegLim:PMC_Left_Status5:12'});
dfs.data_plot('pmclsstatus6','label','Status 6','vars',{'AbsPosValid:PMC_Left_Status6:0','PosStopActive:PMC_Left_Status6:1','NegStopActive:PMC_Left_Status6:2','ConfigSelect:PMC_Left_Status6:4','BrakeCommand:PMC_Left_Status6:5','DigOut1:PMC_Left_Status6:6','DigOut2:PMC_Left_Status6:7'});
dfs.data_plot('pmclg', 'label', 'PMC Left G', 'plots', {'pmclgg'});
dfs.data_plot('pmclgg','label','Gains','vars',{'PMC_Left_VL_Kp','PMC_Left_VL_Ki','PMC_Left_VL_Kd','PMC_Left_TCL_Kp','PMC_Left_TCL_Ki'});
dfs.data_plot('pmcr', 'label', 'PMC Right', 'plots', {'pmcrrpm','pmcrc','pmcrv','pmcrp'});
dfs.data_plot('pmcrrpm','label','RPM','vars',{'PMC_Right_RPM_SP','PMC_Right_RPM_Demand','PMC_Right_RPM'});
dfs.data_plot('pmcrc','label','Current','vars',{'PMC_Right_I_Demand','PMC_Right_I_Measured'});
dfs.data_plot('pmcrv','label','Voltage','vars',{'PMC_Right_BusV'});
dfs.data_plot('pmcrp','label','Position','vars',{'PMC_Right_Pos_SP','PMC_Right_Pos_Demand','PMC_Right_Pos_Target','PMC_Right_Pos_Measured'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('pmcrs', 'label', 'PMC Right S', 'plots', {'pmcrss','pmcrsstatus1','pmcrsstatus2','pmcrsstatus3','pmcrsstatus4','pmcrsstatus5','pmcrsstatus6'});
dfs.data_plot('pmcrss','label','Status 0','vars',{'Bridge_En:PMC_Right_Status0:0','DynBrk_En:PMC_Right_Status0:1','Stop_En:PMC_Right_Status0:2','PosStop_En:PMC_Right_Status0:3','NegStop_En:PMC_Right_Status0:4','PosTrqInh_In:PMC_Right_Status0:5','NegTrqInh_En:PMC_Right_Status0:6','ExtBrk_En:PMC_Right_Status0:7'});
dfs.data_plot('pmcrsstatus1','label','Status 1','vars',{'DrvReset:PMC_Right_Status1:0','DrvIntErr:PMC_Right_Status1:1','ShortCir:PMC_Right_Status1:2','CurOverShoot:PMC_Right_Status1:3','DrvUnderV:PMC_Right_Status1:4','DrvOverV:PMC_Right_Status1:5','DrvOverT:PMC_Right_Status1:6'});
dfs.data_plot('pmcrsstatus2','label','Status 2','vars',{'ParRestoreErr:PMC_Right_Status2:0','ParStoreErr:PMC_Right_Status2:1','InvHallState:PMC_Right_Status2:2','PhaseSyncErr:PMC_Right_Status2:3','MotorOverT:PMC_Right_Status2:4','PhaseDetFault:PMC_Right_Status2:5','FBSensorErr:PMC_Right_Status2:6','MotorOverSpeed:PMC_Right_Status2:7','MaxMeasuredPos:PMC_Right_Status2:8','MinMeasuredPos:PMC_Right_Status2:9','CommError:PMC_Right_Status2:10','PWMBrokenWire:PMC_Right_Status2:11','MotionEngErr:PMC_Right_Status2:12','MotionEngAbrt:PMC_Right_Status2:13'});
dfs.data_plot('pmcrsstatus3','label','Status 3','vars',{'LogEntryMissed:PMC_Right_Status3:0','SWDisable:PMC_Right_Status3:1','UserDisable:PMC_Right_Status3:2','UserPosInh:PMC_Right_Status3:3','UserNegInh:PMC_Right_Status3:4','CurLimiting:PMC_Right_Status3:5','ContCurFoldback:PMC_Right_Status3:6','CurLoopSat:PMC_Right_Status3:7','UserUnderV:PMC_Right_Status3:8','UserOverV:PMC_Right_Status3:9','NonSinComm:PMC_Right_Status3:10','PhaseDetectActive:PMC_Right_Status3:11','MotionEngActive:PMC_Right_Status3:12','UserAuxDisable:PMC_Right_Status3:13','ShuntRegActive:PMC_Right_Status3:14','PhaseDetectDone:PMC_Right_Status3:15'});
dfs.data_plot('pmcrsstatus4','label','Status 4','vars',{'ZeroVel:PMC_Right_Status4:0','AtCommand:PMC_Right_Status4:1','VelFollErr:PMC_Right_Status4:2','PosTargVelLim:PMC_Right_Status4:3','NegTargVelLim:PMC_Right_Status4:4','CmdLimiterAct:PMC_Right_Status4:5','InHomPos:PMC_Right_Status4:6','PosFollErr:PMC_Right_Status4:7','MaxTargPosLim:PMC_Right_Status4:8','MinTargPosLim:PMC_Right_Status4:9','SetPosActive:PMC_Right_Status4:10','HomingActive:PMC_Right_Status4:12','SafeTrqOff:PMC_Right_Status4:13','HomingDone:PMC_Right_Status4:14','ZeroPos:PMC_Right_Status4:15'});
dfs.data_plot('pmcrsstatus5','label','Status 5','vars',{'CmddStop:PMC_Right_Status5:6','UserStop:PMC_Right_Status5:7','Cap1Active:PMC_Right_Status5:8','Cap2Active:PMC_Right_Status5:9','Cap3Active:PMC_Right_Status5:10','CmddPosLim:PMC_Right_Status5:11','CmddNegLim:PMC_Right_Status5:12'});
dfs.data_plot('pmcrsstatus6','label','Status 6','vars',{'AbsPosValid:PMC_Right_Status6:0','PosStopActive:PMC_Right_Status6:1','NegStopActive:PMC_Right_Status6:2','ConfigSelect:PMC_Right_Status6:4','BrakeCommand:PMC_Right_Status6:5','DigOut1:PMC_Right_Status6:6','DigOut2:PMC_Right_Status6:7'});
dfs.data_plot('pmcrg', 'label', 'PMC Right G', 'plots', {'pmcrgg'});
dfs.data_plot('pmcrgg','label','Gains','vars',{'PMC_Right_VL_Kp','PMC_Right_VL_Ki','PMC_Right_VL_Kd','PMC_Right_TCL_Kp','PMC_Right_TCL_Ki'});
dfs.data_plot('bmbvb', 'label', 'B3MB 28V1 Batt', 'plots', {'bmbvbv','bmbvba','bmbvbt','bmbvbs','bmbvbf'});
dfs.data_plot('bmbvbv','label','Volts','vars',{'B3MB_28V1_Batt1_V','B3MB_28V1_Batt2_V','B3MB_28V1_Batt3_V','B3MB_28V1_Batt4_V','B3MB_28V1_Bus_V'});
dfs.data_plot('bmbvba','label','Amps','vars',{'B3MB_28V1_Batt1_I','B3MB_28V1_Batt2_I','B3MB_28V1_Batt3_I','B3MB_28V1_Batt4_I'});
dfs.data_plot('bmbvbt','label','Temp','vars',{'B3MB_28V1_T1','B3MB_28V1_T2','B3MB_28V1_T3','B3MB_28V1_T4','B3MB_28V1_T5'});
dfs.data_plot('bmbvbs','label','Status','vars',{'B1S:B3MB_28V1_Cmd_S:0','B2S:B3MB_28V1_Cmd_S:1','B3S:B3MB_28V1_Cmd_S:2','B4S:B3MB_28V1_Cmd_S:3','Stat_LED:B3MB_28V1_LED_S:0','Fault_LED:B3MB_28V1_LED_S:0','ID_CPU:B3MB_28V1_LED_S:0'});
dfs.data_plot('bmbvbf','label','Fault','vars',{'B1F:B3MB_28V1_Cmd_S:8','B2F:B3MB_28V1_Cmd_S:9','B3F:B3MB_28V1_Cmd_S:10','B4F:B3MB_28V1_Cmd_S:11'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('bmbvl', 'label', 'B3MB 28V1 Load', 'plots', {'bmbvlv','bmbvla','bmbvls','bmbvlf'});
dfs.data_plot('bmbvlv','label','Volts','vars',{'B3MB_28V1_Load1_V','B3MB_28V1_Load2_V','B3MB_28V1_Load3_V','B3MB_28V1_Load4_V'});
dfs.data_plot('bmbvla','label','Amps','vars',{'B3MB_28V1_Load1_I','B3MB_28V1_Load2_I','B3MB_28V1_Load3_I','B3MB_28V1_Load4_I'});
dfs.data_plot('bmbvls','label','Status','vars',{'L1S:B3MB_28V1_Cmd_S:4','L2S:B3MB_28V1_Cmd_S:5','L3S:B3MB_28V1_Cmd_S:6','L4S:B3MB_28V1_Cmd_S:7'});
dfs.data_plot('bmbvlf','label','Fault','vars',{'L1F:B3MB_28V1_Cmd_S:12','L2F:B3MB_28V1_Cmd_S:13','L3F:B3MB_28V1_Cmd_S:14','L4F:B3MB_28V1_Cmd_S:15'});
dfs.data_plot('b3mb_100v1_batt', 'label', 'B3MB 100V1 Batt', 'plots', {'b3mb_100v1_battv','b3mb_100v1_batta','b3mb_100v1_battt','b3mb_100v1_batts','b3mb_100v1_battf'});
dfs.data_plot('b3mb_100v1_battv','label','Volts','vars',{'B3MB_100V1_Batt1_V','B3MB_100V1_Batt2_V','B3MB_100V1_Batt3_V','B3MB_100V1_Batt4_V','B3MB_100V1_Bus_V'});
dfs.data_plot('b3mb_100v1_batta','label','Amps','vars',{'B3MB_100V1_Batt1_I','B3MB_100V1_Batt2_I','B3MB_100V1_Batt3_I','B3MB_100V1_Batt4_I'});
dfs.data_plot('b3mb_100v1_battt','label','Temp','vars',{'B3MB_100V1_T1','B3MB_100V1_T2','B3MB_100V1_T3','B3MB_100V1_T4','B3MB_100V1_T5'});
dfs.data_plot('b3mb_100v1_batts','label','Status','vars',{'B1S:B3MB_100V1_Cmd_S:0','B2S:B3MB_100V1_Cmd_S:1','B3S:B3MB_100V1_Cmd_S:2','B4S:B3MB_100V1_Cmd_S:3','Stat_LED:B3MB_100V1_LED_S:0','Fault_LED:B3MB_100V1_LED_S:0','ID_CPU:B3MB_100V1_LED_S:0'});
dfs.data_plot('b3mb_100v1_battf','label','Fault','vars',{'B1F:B3MB_100V1_Cmd_S:8','B2F:B3MB_100V1_Cmd_S:9','B3F:B3MB_100V1_Cmd_S:10','B4F:B3MB_100V1_Cmd_S:11'});
dfs.data_plot('b3mb_100v1_load', 'label', 'B3MB 100V1 Load', 'plots', {'b3mb_100v1_loadv','b3mb_100v1_loada','b3mb_100v1_loads','b3mb_100v1_loadf'});
dfs.data_plot('b3mb_100v1_loadv','label','Volts','vars',{'B3MB_100V1_Load1_V','B3MB_100V1_Load2_V','B3MB_100V1_Load3_V','B3MB_100V1_Load4_V'});
dfs.data_plot('b3mb_100v1_loada','label','Amps','vars',{'B3MB_100V1_Load1_I','B3MB_100V1_Load2_I','B3MB_100V1_Load3_I','B3MB_100V1_Load4_I'});
dfs.data_plot('b3mb_100v1_loads','label','Status','vars',{'L1S:B3MB_100V1_Cmd_S:4','L2S:B3MB_100V1_Cmd_S:5','L3S:B3MB_100V1_Cmd_S:6','L4S:B3MB_100V1_Cmd_S:7'});
dfs.data_plot('b3mb_100v1_loadf','label','Fault','vars',{'L1F:B3MB_100V1_Cmd_S:12','L2F:B3MB_100V1_Cmd_S:13','L3F:B3MB_100V1_Cmd_S:14','L4F:B3MB_100V1_Cmd_S:15'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('b3mb_100v2_batt', 'label', 'B3MB 100V2 Batt', 'plots', {'b3mb_100v2_battv','b3mb_100v2_batta','b3mb_100v2_battt','b3mb_100v2_batts','b3mb_100v2_battf'});
dfs.data_plot('b3mb_100v2_battv','label','Volts','vars',{'B3MB_100V2_Batt1_V','B3MB_100V2_Batt2_V','B3MB_100V2_Batt3_V','B3MB_100V2_Batt4_V','B3MB_100V2_Bus_V'});
dfs.data_plot('b3mb_100v2_batta','label','Amps','vars',{'B3MB_100V2_Batt1_I','B3MB_100V2_Batt2_I','B3MB_100V2_Batt3_I','B3MB_100V2_Batt4_I'});
dfs.data_plot('b3mb_100v2_battt','label','Temp','vars',{'B3MB_100V2_T1','B3MB_100V2_T2','B3MB_100V2_T3','B3MB_100V2_T4','B3MB_100V2_T5'});
dfs.data_plot('b3mb_100v2_batts','label','Status','vars',{'B1S:B3MB_100V2_Cmd_S:0','B2S:B3MB_100V2_Cmd_S:1','B3S:B3MB_100V2_Cmd_S:2','B4S:B3MB_100V2_Cmd_S:3','Stat_LED:B3MB_100V2_LED_S:0','Fault_LED:B3MB_100V2_LED_S:0','ID_CPU:B3MB_100V2_LED_S:0'});
dfs.data_plot('b3mb_100v2_battf','label','Fault','vars',{'B1F:B3MB_100V2_Cmd_S:8','B2F:B3MB_100V2_Cmd_S:9','B3F:B3MB_100V2_Cmd_S:10','B4F:B3MB_100V2_Cmd_S:11'});
dfs.data_plot('b3mb_100v2_load', 'label', 'B3MB 100V2 Load', 'plots', {'b3mb_100v2_loadv','b3mb_100v2_loada','b3mb_100v2_loads','b3mb_100v2_loadf'});
dfs.data_plot('b3mb_100v2_loadv','label','Volts','vars',{'B3MB_100V2_Load1_V','B3MB_100V2_Load2_V','B3MB_100V2_Load3_V','B3MB_100V2_Load4_V'});
dfs.data_plot('b3mb_100v2_loada','label','Amps','vars',{'B3MB_100V2_Load1_I','B3MB_100V2_Load2_I','B3MB_100V2_Load3_I','B3MB_100V2_Load4_I'});
dfs.data_plot('b3mb_100v2_loads','label','Status','vars',{'L1S:B3MB_100V2_Cmd_S:4','L2S:B3MB_100V2_Cmd_S:5','L3S:B3MB_100V2_Cmd_S:6','L4S:B3MB_100V2_Cmd_S:7'});
dfs.data_plot('b3mb_100v2_loadf','label','Fault','vars',{'L1F:B3MB_100V2_Cmd_S:12','L2F:B3MB_100V2_Cmd_S:13','L3F:B3MB_100V2_Cmd_S:14','L4F:B3MB_100V2_Cmd_S:15'});
dfs.data_plot('b3mb_100v3_batt', 'label', 'B3MB 100V3 Batt', 'plots', {'b3mb_100v3_battv','b3mb_100v3_batta','b3mb_100v3_battt','b3mb_100v3_batts','b3mb_100v3_battf'});
dfs.data_plot('b3mb_100v3_battv','label','Volts','vars',{'B3MB_100V3_Batt1_V','B3MB_100V3_Batt2_V','B3MB_100V3_Batt3_V','B3MB_100V3_Batt4_V','B3MB_100V3_Bus_V'});
dfs.data_plot('b3mb_100v3_batta','label','Amps','vars',{'B3MB_100V3_Batt1_I','B3MB_100V3_Batt2_I','B3MB_100V3_Batt3_I','B3MB_100V3_Batt4_I'});
dfs.data_plot('b3mb_100v3_battt','label','Temp','vars',{'B3MB_100V3_T1','B3MB_100V3_T2','B3MB_100V3_T3','B3MB_100V3_T4','B3MB_100V3_T5'});
dfs.data_plot('b3mb_100v3_batts','label','Status','vars',{'B1S:B3MB_100V3_Cmd_S:0','B2S:B3MB_100V3_Cmd_S:1','B3S:B3MB_100V3_Cmd_S:2','B4S:B3MB_100V3_Cmd_S:3','Stat_LED:B3MB_100V3_LED_S:0','Fault_LED:B3MB_100V3_LED_S:0','ID_CPU:B3MB_100V3_LED_S:0'});
dfs.data_plot('b3mb_100v3_battf','label','Fault','vars',{'B1F:B3MB_100V3_Cmd_S:8','B2F:B3MB_100V3_Cmd_S:9','B3F:B3MB_100V3_Cmd_S:10','B4F:B3MB_100V3_Cmd_S:11'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('b3mb_100v3_load', 'label', 'B3MB 100V3 Load', 'plots', {'b3mb_100v3_loadv','b3mb_100v3_loada','b3mb_100v3_loads','b3mb_100v3_loadf'});
dfs.data_plot('b3mb_100v3_loadv','label','Volts','vars',{'B3MB_100V3_Load1_V','B3MB_100V3_Load2_V','B3MB_100V3_Load3_V','B3MB_100V3_Load4_V'});
dfs.data_plot('b3mb_100v3_loada','label','Amps','vars',{'B3MB_100V3_Load1_I','B3MB_100V3_Load2_I','B3MB_100V3_Load3_I','B3MB_100V3_Load4_I'});
dfs.data_plot('b3mb_100v3_loads','label','Status','vars',{'L1S:B3MB_100V3_Cmd_S:4','L2S:B3MB_100V3_Cmd_S:5','L3S:B3MB_100V3_Cmd_S:6','L4S:B3MB_100V3_Cmd_S:7'});
dfs.data_plot('b3mb_100v3_loadf','label','Fault','vars',{'L1F:B3MB_100V3_Cmd_S:12','L2F:B3MB_100V3_Cmd_S:13','L3F:B3MB_100V3_Cmd_S:14','L4F:B3MB_100V3_Cmd_S:15'});
dfs.data_plot('b3mb_100v4_batt', 'label', 'B3MB 100V4 Batt', 'plots', {'b3mb_100v4_battv','b3mb_100v4_batta','b3mb_100v4_battt','b3mb_100v4_batts','b3mb_100v4_battf'});
dfs.data_plot('b3mb_100v4_battv','label','Volts','vars',{'B3MB_100V4_Batt1_V','B3MB_100V4_Batt2_V','B3MB_100V4_Batt3_V','B3MB_100V4_Batt4_V','B3MB_100V4_Bus_V'});
dfs.data_plot('b3mb_100v4_batta','label','Amps','vars',{'B3MB_100V4_Batt1_I','B3MB_100V4_Batt2_I','B3MB_100V4_Batt3_I','B3MB_100V4_Batt4_I'});
dfs.data_plot('b3mb_100v4_battt','label','Temp','vars',{'B3MB_100V4_T1','B3MB_100V4_T2','B3MB_100V4_T3','B3MB_100V4_T4','B3MB_100V4_T5'});
dfs.data_plot('b3mb_100v4_batts','label','Status','vars',{'B1S:B3MB_100V4_Cmd_S:0','B2S:B3MB_100V4_Cmd_S:1','B3S:B3MB_100V4_Cmd_S:2','B4S:B3MB_100V4_Cmd_S:3','Stat_LED:B3MB_100V4_LED_S:0','Fault_LED:B3MB_100V4_LED_S:0','ID_CPU:B3MB_100V4_LED_S:0'});
dfs.data_plot('b3mb_100v4_battf','label','Fault','vars',{'B1F:B3MB_100V4_Cmd_S:8','B2F:B3MB_100V4_Cmd_S:9','B3F:B3MB_100V4_Cmd_S:10','B4F:B3MB_100V4_Cmd_S:11'});
dfs.data_plot('b3mb_100v4_load', 'label', 'B3MB 100V4 Load', 'plots', {'b3mb_100v4_loadv','b3mb_100v4_loada','b3mb_100v4_loads','b3mb_100v4_loadf'});
dfs.data_plot('b3mb_100v4_loadv','label','Volts','vars',{'B3MB_100V4_Load1_V','B3MB_100V4_Load2_V','B3MB_100V4_Load3_V','B3MB_100V4_Load4_V'});
dfs.data_plot('b3mb_100v4_loada','label','Amps','vars',{'B3MB_100V4_Load1_I','B3MB_100V4_Load2_I','B3MB_100V4_Load3_I','B3MB_100V4_Load4_I'});
dfs.data_plot('b3mb_100v4_loads','label','Status','vars',{'L1S:B3MB_100V4_Cmd_S:4','L2S:B3MB_100V4_Cmd_S:5','L3S:B3MB_100V4_Cmd_S:6','L4S:B3MB_100V4_Cmd_S:7'});
dfs.data_plot('b3mb_100v4_loadf','label','Fault','vars',{'L1F:B3MB_100V4_Cmd_S:12','L2F:B3MB_100V4_Cmd_S:13','L3F:B3MB_100V4_Cmd_S:14','L4F:B3MB_100V4_Cmd_S:15'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('gnss', 'label', 'GNSS', 'plots', {'gnsss','gnssf','gnssd','gnssp','gnssv','gnssh','gnssa','gnssattitude','gnssav','gnssstd','gnssstale'});
dfs.data_plot('gnsss','label','System','vars',{'system_status'});
dfs.data_plot('gnssf','label','Filters','vars',{'orient_init:filter_status:0','nav_init:filter_status:1','heading_init:filter_status:2','UTC_init:filter_status:3','Int_GNSS_en:filter_status:9','dual_heading_active:filter_status:10','atm_alt_en:filter_status:12'});
dfs.data_plot('gnssd','label','Drift','vars',{'nav_drift'});
dfs.data_plot('gnssp','label','Position','vars',{'latitude','longitude','height'});
dfs.data_plot('gnssv','label','Velocity','vars',{'velocity_north','velocity_east','velocity_forward','velocity_down'});
dfs.data_plot('gnssh','label','Heading','vars',{'Track','heading'});
dfs.data_plot('gnssa','label','Accel','vars',{'body_accel_x','body_accel_y','body_accel_z','g_force'});
dfs.data_plot('gnssattitude','label','Attitude','vars',{'roll','pitch'});
dfs.data_plot('gnssav','label','Ang Vel','vars',{'angular_velocity_x','angular_velocity_y','angular_velocity_z'});
dfs.data_plot('gnssstd','label','Std','vars',{'latitude_std','longitude_std','height_std'});
dfs.data_plot('gnssstale','label','Stale','vars',{'SD_stale','SD_n_reports','SD_nc'});
dfs.data_plot('a', 'label', 'Ascender', 'plots', {'ap','as','ac','al'});
dfs.data_plot('ap','label','Pos','vars',{'AscPosition'});
dfs.data_plot('as','label','Speed','vars',{'AscSpeed'});
dfs.data_plot('ac','label','Cmd','vars',{'AscSpeedCmd'});
dfs.data_plot('al','label','Limits','vars',{'AscLimit1:AscStatus:4','AscLimit2:AscStatus:4'});
dfs.end_col;
dfs.start_col;
dfs.data_plot('ahk', 'label', 'Asc HK', 'plots', {'ahkv','ahki','ahkci','ahkm','ahkt','ahkn','ahks'});
dfs.data_plot('ahkv','label','V','vars',{'AscHoistV'});
dfs.data_plot('ahki','label','I','vars',{'AscHoistI'});
dfs.data_plot('ahkci','label','Ctrl Inp','vars',{'AscCtrlInp'});
dfs.data_plot('ahkm','label','Mode','vars',{'AscMode'});
dfs.data_plot('ahkt','label','Temp','vars',{'AscMtrT','AscMtrCtrlT','AscOutputPulleyT','AscConvT'});
dfs.data_plot('ahkn','label','Nreports','vars',{'AscNreports'});
dfs.data_plot('ahks','label','Stale','vars',{'AscStale'});
dfs.end_col;
dfs.resize;
dfs.set_connection('127.0.0.1', 1080);
