function pchgb3mb100a_b3mb_100v4_loads(varargin)
% pchgb3mb100a_b3mb_100v4_loads( [...] );
% B3MB 100V4 Load Status
h = ne_dstat({
  'B3MB_100V4_Load1S', 'B3MB_100V4_Cmd_S', 4; ...
	'B3MB_100V4_Load2S', 'B3MB_100V4_Cmd_S', 5; ...
	'B3MB_100V4_Load3S', 'B3MB_100V4_Cmd_S', 6; ...
	'B3MB_100V4_Load4S', 'B3MB_100V4_Cmd_S', 7 }, 'Status', varargin{:} );
