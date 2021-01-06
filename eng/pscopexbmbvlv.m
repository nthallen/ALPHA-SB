function pscopexbmbvlv(varargin);
% pscopexbmbvlv( [...] );
% B3MB 100V1 Load Volts
h = timeplot({'B3MB_100V1_Load1_V','B3MB_100V1_Load2_V','B3MB_100V1_Load3_V','B3MB_100V1_Load4_V'}, ...
      'B3MB 100V1 Load Volts', ...
      'Volts', ...
      {'L1V','L2V','L3V','L4V'}, ...
      varargin{:} );