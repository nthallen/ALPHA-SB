function pchgb3mb_b3mb_100v1_loada(varargin);
% pchgb3mb_b3mb_100v1_loada( [...] );
% B3MB 100V1 Load Amps
h = timeplot({'B3MB_100V1_Load1_I','B3MB_100V1_Load2_I','B3MB_100V1_Load3_I','B3MB_100V1_Load4_I'}, ...
      'B3MB 100V1 Load Amps', ...
      'Amps', ...
      {'L1I','L1I','L1I','L1I'}, ...
      varargin{:} );
