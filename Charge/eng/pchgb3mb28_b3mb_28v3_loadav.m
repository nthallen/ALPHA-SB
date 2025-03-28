function pchgb3mb28_b3mb_28v3_loadav(varargin)
% pchgb3mb28_b3mb_28v3_loadav( [...] );
% B3MB 28V3 Load Amps 28V3
h = timeplot({'B3MB_28V3_Load1_I','B3MB_28V3_Load2_I','B3MB_28V3_Load3_I','B3MB_28V3_Load4_I'}, ...
      'B3MB 28V3 Load Amps 28V3', ...
      'Amps 28V3', ...
      {'L1I','L2I','L3I','L4I'}, ...
      varargin{:} );
