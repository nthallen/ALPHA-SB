function pscopexbmbvba(varargin);
% pscopexbmbvba( [...] );
% B3MB 28V1 Batt Amps
h = timeplot({'B3MB_28V1_Batt1_I','B3MB_28V1_Batt2_I','B3MB_28V1_Batt3_I','B3MB_28V1_Batt4_I'}, ...
      'B3MB 28V1 Batt Amps', ...
      'Amps', ...
      {'B1I','B2I','B3I','B4I'}, ...
      varargin{:} );
