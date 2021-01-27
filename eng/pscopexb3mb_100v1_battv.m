function pscopexb3mb_100v1_battv(varargin);
% pscopexb3mb_100v1_battv( [...] );
% B3MB 100V1 Batt Volts
h = timeplot({'B3MB_100V1_Batt1_V','B3MB_100V1_Batt2_V','B3MB_100V1_Batt3_V','B3MB_100V1_Batt4_V','B3MB_100V1_Bus_V'}, ...
      'B3MB 100V1 Batt Volts', ...
      'Volts', ...
      {'B1V','B2V','B3V','B4V','BusV'}, ...
      varargin{:} );
