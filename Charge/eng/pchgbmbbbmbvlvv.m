function pchgbmbbbmbvlvv(varargin)
% pchgbmbbbmbvlvv( [...] );
% B3MB 100V5 Load Volts 100V5
h = timeplot({'B3MB_100V5_Load1_V','B3MB_100V5_Load2_V','B3MB_100V5_Load3_V','B3MB_100V5_Load4_V'}, ...
      'B3MB 100V5 Load Volts 100V5', ...
      'Volts 100V5', ...
      {'L1V','L2V','L3V','L4V'}, ...
      varargin{:} );
