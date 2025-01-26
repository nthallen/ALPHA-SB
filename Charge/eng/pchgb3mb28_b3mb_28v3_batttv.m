function pchgb3mb28_b3mb_28v3_batttv(varargin)
% pchgb3mb28_b3mb_28v3_batttv( [...] );
% B3MB 28V3 Batt Temp 28V3
h = timeplot({'B3MB_28V3_T1','B3MB_28V3_T2','B3MB_28V3_T3','B3MB_28V3_T4'}, ...
      'B3MB 28V3 Batt Temp 28V3', ...
      'Temp 28V3', ...
      {'T1','T2','T3','T4'}, ...
      varargin{:} );
