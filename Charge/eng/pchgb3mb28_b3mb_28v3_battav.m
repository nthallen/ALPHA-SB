function pchgb3mb28_b3mb_28v3_battav(varargin)
% pchgb3mb28_b3mb_28v3_battav( [...] );
% B3MB 28V3 Batt Amps 28V3
h = timeplot({'B3MB_28V3_Batt1_I','B3MB_28V3_Batt2_I','B3MB_28V3_Batt3_I','B3MB_28V3_Batt4_I'}, ...
      'B3MB 28V3 Batt Amps 28V3', ...
      'Amps 28V3', ...
      {'B1I','B2I','B3I','B4I'}, ...
      varargin{:} );
