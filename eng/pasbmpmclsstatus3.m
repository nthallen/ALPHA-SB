function pasbmpmclsstatus3(varargin);
% pasbmpmclsstatus3( [...] );
% PMC Left S Status 3
h = ne_dstat({
  'Left_LogEntryMissed', 'PMC_Left_Status3', 0; ...
	'Left_SWDisable', 'PMC_Left_Status3', 1; ...
	'Left_UserDisable', 'PMC_Left_Status3', 2; ...
	'Left_UserPosInh', 'PMC_Left_Status3', 3; ...
	'Left_UserNegInh', 'PMC_Left_Status3', 4; ...
	'Left_CurLimiting', 'PMC_Left_Status3', 5; ...
	'Left_ContCurFoldback', 'PMC_Left_Status3', 6; ...
	'Left_CurLoopSat', 'PMC_Left_Status3', 7; ...
	'Left_UserUnderV', 'PMC_Left_Status3', 8; ...
	'Left_UserOverV', 'PMC_Left_Status3', 9; ...
	'Left_NonSinComm', 'PMC_Left_Status3', 10; ...
	'Left_PhaseDetectActive', 'PMC_Left_Status3', 11; ...
	'Left_MotionEngActive', 'PMC_Left_Status3', 12; ...
	'Left_UserAuxDisable', 'PMC_Left_Status3', 13; ...
	'Left_ShuntRegActive', 'PMC_Left_Status3', 14; ...
	'Left_PhaseDetectDone', 'PMC_Left_Status3', 15 }, 'Status 3', varargin{:} );
