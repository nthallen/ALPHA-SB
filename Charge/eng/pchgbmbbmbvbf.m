function pchgbmbbmbvbf(varargin);
% pchgbmbbmbvbf( [...] );
% B3MB 28V1 Batt Fault
h = ne_dstat({
  'B3MB_28V1_B1F', 'B3MB_28V1_Cmd_S', 8; ...
	'B3MB_28V1_B2F', 'B3MB_28V1_Cmd_S', 9; ...
	'B3MB_28V1_B3F', 'B3MB_28V1_Cmd_S', 10; ...
	'B3MB_28V1_B4F', 'B3MB_28V1_Cmd_S', 11 }, 'Fault', varargin{:} );
