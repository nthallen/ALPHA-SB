function pscopexmpmclsstatus2(varargin);
% pscopexmpmclsstatus2( [...] );
% PMC Left S Status 2
h = ne_dstat({
  'Left_ParRestoreErr', 'PMC_Left_Status2', 0; ...
	'Left_ParStoreErr', 'PMC_Left_Status2', 1; ...
	'Left_InvHallState', 'PMC_Left_Status2', 2; ...
	'Left_PhaseSyncErr', 'PMC_Left_Status2', 3; ...
	'Left_MotorOverT', 'PMC_Left_Status2', 4; ...
	'Left_PhaseDetFault', 'PMC_Left_Status2', 5; ...
	'Left_FBSensorErr', 'PMC_Left_Status2', 6; ...
	'Left_MotorOverSpeed', 'PMC_Left_Status2', 7; ...
	'Left_MaxMeasuredPos', 'PMC_Left_Status2', 8; ...
	'Left_MinMeasuredPos', 'PMC_Left_Status2', 9; ...
	'Left_CommError', 'PMC_Left_Status2', 10; ...
	'Left_PWMBrokenWire', 'PMC_Left_Status2', 11; ...
	'Left_MotionEngErr', 'PMC_Left_Status2', 12; ...
	'Left_MotionEngAbrt', 'PMC_Left_Status2', 13 }, 'Status 2', varargin{:} );
