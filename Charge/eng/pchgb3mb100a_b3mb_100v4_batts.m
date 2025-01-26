function pchgb3mb100a_b3mb_100v4_batts(varargin)
% pchgb3mb100a_b3mb_100v4_batts( [...] );
% B3MB 100V4 Batt Status
h = ne_dstat({
  'B3MB_100V4_B1S', 'B3MB_100V4_Cmd_S', 0; ...
	'B3MB_100V4_Stat_LED', 'B3MB_100V4_LED_S', 0; ...
	'B3MB_100V4_Fault_LED', 'B3MB_100V4_LED_S', 1; ...
	'B3MB_100V4_ID_CPU', 'B3MB_100V4_LED_S', 2 }, 'Status', varargin{:} );
