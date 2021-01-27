function pscopexb3mb_100v1_batta(varargin);
% pscopexb3mb_100v1_batta( [...] );
% B3MB 100V1 Batt Amps
h = timeplot({'B3MB_100V1_Batt1_I','B3MB_100V1_Batt2_I','B3MB_100V1_Batt3_I','B3MB_100V1_Batt4_I'}, ...
      'B3MB 100V1 Batt Amps', ...
      'Amps', ...
      {'B1I','B2I','B3I','B4I'}, ...
      varargin{:} );
