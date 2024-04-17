function pasbb3mb100b_b3mb_100v6_battf(varargin);
% pasbb3mb100b_b3mb_100v6_battf( [...] );
% B3MB 100V6 Batt Fault
h = ne_dstat({
  'B3MB_100V6_B1F', 'B3MB_100V6_Cmd_S', 8 }, 'Fault', varargin{:} );
