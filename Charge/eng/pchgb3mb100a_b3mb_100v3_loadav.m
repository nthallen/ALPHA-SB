function pchgb3mb100a_b3mb_100v3_loadav(varargin)
% pchgb3mb100a_b3mb_100v3_loadav( [...] );
% B3MB 100V3 Load Amps 100V3
h = timeplot({'B3MB_100V3_Load1_I','B3MB_100V3_Load2_I','B3MB_100V3_Load3_I','B3MB_100V3_Load4_I'}, ...
      'B3MB 100V3 Load Amps 100V3', ...
      'Amps 100V3', ...
      {'L1I','L2I','L3I','L4I'}, ...
      varargin{:} );
