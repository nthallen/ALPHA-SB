function pchgb3mb28_b3mb_28v2_loadf(varargin)
% pchgb3mb28_b3mb_28v2_loadf( [...] );
% B3MB 28V2 Load Fault
h = ne_dstat({
  'B3MB_28V2_Load1F', 'B3MB_28V2_Cmd_S', 12; ...
	'B3MB_28V2_Load2F', 'B3MB_28V2_Cmd_S', 13; ...
	'B3MB_28V2_Load3F', 'B3MB_28V2_Cmd_S', 14; ...
	'B3MB_28V2_Load4F', 'B3MB_28V2_Cmd_S', 15 }, 'Fault', varargin{:} );
