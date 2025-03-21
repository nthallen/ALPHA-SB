function pchgb3mb100b_b3mb_100v6_batts(varargin)
% pchgb3mb100b_b3mb_100v6_batts( [...] );
% B3MB 100V6 Batt Status
h = ne_dstat({
  'B3MB_100V6_B1S', 'B3MB_100V6_Cmd_S', 0; ...
	'B3MB_100V6_Stat_LED', 'B3MB_100V6_LED_S', 0; ...
	'B3MB_100V6_Fault_LED', 'B3MB_100V6_LED_S', 1; ...
	'B3MB_100V6_ID_CPU', 'B3MB_100V6_LED_S', 2 }, 'Status', varargin{:} );
