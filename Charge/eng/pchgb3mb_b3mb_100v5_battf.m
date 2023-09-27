function pchgb3mb_b3mb_100v5_battf(varargin);
% pchgb3mb_b3mb_100v5_battf( [...] );
% B3MB 100V5 Batt Fault
h = ne_dstat({
  'B3MB_100V5_B1F', 'B3MB_100V5_Cmd_S', 8 }, 'Fault', varargin{:} );
