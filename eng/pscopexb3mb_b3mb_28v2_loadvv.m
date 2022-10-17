function pscopexb3mb_b3mb_28v2_loadvv(varargin);
% pscopexb3mb_b3mb_28v2_loadvv( [...] );
% B3MB 28V2 Load Volts 28V2
h = timeplot({'B3MB_28V2_Load1_V','B3MB_28V2_Load2_V','B3MB_28V2_Load3_V','B3MB_28V2_Load4_V'}, ...
      'B3MB 28V2 Load Volts 28V2', ...
      'Volts 28V2', ...
      {'L1V','L2V','L3V','L4V'}, ...
      varargin{:} );
