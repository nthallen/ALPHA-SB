function pchgb3mb100b_b3mb_100v8_loadav(varargin)
% pchgb3mb100b_b3mb_100v8_loadav( [...] );
% B3MB 100V8 Load Amps 100V8
h = timeplot({'B3MB_100V8_Load1_I','B3MB_100V8_Load2_I','B3MB_100V8_Load3_I','B3MB_100V8_Load4_I'}, ...
      'B3MB 100V8 Load Amps 100V8', ...
      'Amps 100V8', ...
      {'L1I','L2I','L3I','L4I'}, ...
      varargin{:} );
