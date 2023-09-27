function pchgb3mb_b3mb_100v8_battf(varargin);
% pchgb3mb_b3mb_100v8_battf( [...] );
% B3MB 100V8 Batt Fault
h = ne_dstat({
  'B3MB_100V8_B1F', 'B3MB_100V8_Cmd_S', 8 }, 'Fault', varargin{:} );
