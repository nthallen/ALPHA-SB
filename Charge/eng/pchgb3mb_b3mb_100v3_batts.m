function pchgb3mb_b3mb_100v3_batts(varargin);
% pchgb3mb_b3mb_100v3_batts( [...] );
% B3MB 100V3 Batt Status
h = ne_dstat({
  'B3MB_100V3_B1S', 'B3MB_100V3_Cmd_S', 0; ...
	'B3MB_100V3_B2S', 'B3MB_100V3_Cmd_S', 1; ...
	'B3MB_100V3_B3S', 'B3MB_100V3_Cmd_S', 2; ...
	'B3MB_100V3_B4S', 'B3MB_100V3_Cmd_S', 3; ...
	'B3MB_100V3_Stat_LED', 'B3MB_100V3_LED_S', 0; ...
	'B3MB_100V3_Fault_LED', 'B3MB_100V3_LED_S', 1; ...
	'B3MB_100V3_ID_CPU', 'B3MB_100V3_LED_S', 2 }, 'Status', varargin{:} );
