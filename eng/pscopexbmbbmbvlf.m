function pscopexbmbbmbvlf(varargin);
% pscopexbmbbmbvlf( [...] );
% B3MB 28V1 Load Fault
h = ne_dstat({
  'B3MB_28V1_L1F', 'B3MB_28V1_Cmd_S', 12; ...
	'B3MB_28V1_L2F', 'B3MB_28V1_Cmd_S', 13; ...
	'B3MB_28V1_L3F', 'B3MB_28V1_Cmd_S', 14; ...
	'B3MB_28V1_L4F', 'B3MB_28V1_Cmd_S', 15 }, 'Fault', varargin{:} );
