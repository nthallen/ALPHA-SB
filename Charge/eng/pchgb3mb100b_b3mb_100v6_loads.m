function pchgb3mb100b_b3mb_100v6_loads(varargin);
% pchgb3mb100b_b3mb_100v6_loads( [...] );
% B3MB 100V6 Load Status
h = ne_dstat({
  'B3MB_100V6_Load1S', 'B3MB_100V6_Cmd_S', 4; ...
	'B3MB_100V6_Load2S', 'B3MB_100V6_Cmd_S', 5; ...
	'B3MB_100V6_Load3S', 'B3MB_100V6_Cmd_S', 6; ...
	'B3MB_100V6_Load4S', 'B3MB_100V6_Cmd_S', 7 }, 'Status', varargin{:} );