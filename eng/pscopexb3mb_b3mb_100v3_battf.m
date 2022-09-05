function pscopexb3mb_b3mb_100v3_battf(varargin);
% pscopexb3mb_b3mb_100v3_battf( [...] );
% B3MB 100V3 Batt Fault
h = ne_dstat({
  'B3MB_100V3_B1F', 'B3MB_100V3_Cmd_S', 8 }, 'Fault', varargin{:} );
