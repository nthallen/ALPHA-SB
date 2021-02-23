function pscopexb3mb_28v2_battv(varargin);
% pscopexb3mb_28v2_battv( [...] );
% B3MB 28V2 Batt Volts
h = timeplot({'B3MB_28V2_Batt1_V','B3MB_28V2_Batt2_V','B3MB_28V2_Batt3_V','B3MB_28V2_Batt4_V','B3MB_28V2_Bus_V'}, ...
      'B3MB 28V2 Batt Volts', ...
      'Volts', ...
      {'B1V','B2V','B3V','B4V','BusV'}, ...
      varargin{:} );