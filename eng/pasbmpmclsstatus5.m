function pasbmpmclsstatus5(varargin);
% pasbmpmclsstatus5( [...] );
% PMC Left S Status 5
h = ne_dstat({
  'Left_CmddStop', 'PMC_Left_Status5', 6; ...
	'Left_UserStop', 'PMC_Left_Status5', 7; ...
	'Left_Cap1Active', 'PMC_Left_Status5', 8; ...
	'Left_Cap2Active', 'PMC_Left_Status5', 9; ...
	'Left_Cap3Active', 'PMC_Left_Status5', 10; ...
	'Left_CmddPosLim', 'PMC_Left_Status5', 11; ...
	'Left_CmddNegLim', 'PMC_Left_Status5', 12 }, 'Status 5', varargin{:} );