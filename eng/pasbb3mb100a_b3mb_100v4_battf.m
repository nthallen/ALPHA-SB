function pasbb3mb100a_b3mb_100v4_battf(varargin);
% pasbb3mb100a_b3mb_100v4_battf( [...] );
% B3MB 100V4 Batt Fault
h = ne_dstat({
  'B3MB_100V4_B1F', 'B3MB_100V4_Cmd_S', 8 }, 'Fault', varargin{:} );
