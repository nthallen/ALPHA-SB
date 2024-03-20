function pchgbmbbbmbvbf(varargin);
% pchgbmbbbmbvbf( [...] );
% B3MB 100V5 Batt Fault
h = ne_dstat({
  'B3MB_100V5_B1F', 'B3MB_100V5_Cmd_S', 8 }, 'Fault', varargin{:} );
