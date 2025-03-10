function pchgb3mb28_b3mb_28v3_battf(varargin)
% pchgb3mb28_b3mb_28v3_battf( [...] );
% B3MB 28V3 Batt Fault
h = ne_dstat({
  'B3MB_28V3_B1F', 'B3MB_28V3_Cmd_S', 8; ...
	'B3MB_28V3_B2F', 'B3MB_28V3_Cmd_S', 9; ...
	'B3MB_28V3_B3F', 'B3MB_28V3_Cmd_S', 10; ...
	'B3MB_28V3_B4F', 'B3MB_28V3_Cmd_S', 11 }, 'Fault', varargin{:} );
