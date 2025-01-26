function pchgb3mb100a_b3mb_100v2_battf(varargin)
% pchgb3mb100a_b3mb_100v2_battf( [...] );
% B3MB 100V2 Batt Fault
h = ne_dstat({
  'B3MB_100V2_B1F', 'B3MB_100V2_Cmd_S', 8 }, 'Fault', varargin{:} );
