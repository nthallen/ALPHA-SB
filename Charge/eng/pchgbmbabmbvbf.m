function pchgbmbabmbvbf(varargin);
% pchgbmbabmbvbf( [...] );
% B3MB 100V1 Batt Fault
h = ne_dstat({
  'B3MB_100V1_B1F', 'B3MB_100V1_Cmd_S', 8 }, 'Fault', varargin{:} );
