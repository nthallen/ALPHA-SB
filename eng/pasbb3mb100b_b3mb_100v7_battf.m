function pasbb3mb100b_b3mb_100v7_battf(varargin);
% pasbb3mb100b_b3mb_100v7_battf( [...] );
% B3MB 100V7 Batt Fault
h = ne_dstat({
  'B3MB_100V7_B1F', 'B3MB_100V7_Cmd_S', 8 }, 'Fault', varargin{:} );
