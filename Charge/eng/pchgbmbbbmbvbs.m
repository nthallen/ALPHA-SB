function pchgbmbbbmbvbs(varargin)
% pchgbmbbbmbvbs( [...] );
% B3MB 100V5 Batt Status
h = ne_dstat({
  'B3MB_100V5_B1S', 'B3MB_100V5_Cmd_S', 0; ...
	'B3MB_100V5_Stat_LED', 'B3MB_100V5_LED_S', 0; ...
	'B3MB_100V5_Fault_LED', 'B3MB_100V5_LED_S', 1; ...
	'B3MB_100V5_ID_CPU', 'B3MB_100V5_LED_S', 2 }, 'Status', varargin{:} );
