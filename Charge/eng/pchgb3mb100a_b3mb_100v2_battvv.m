function pchgb3mb100a_b3mb_100v2_battvv(varargin)
% pchgb3mb100a_b3mb_100v2_battvv( [...] );
% B3MB 100V2 Batt Volts 100V2
h = timeplot({'B3MB_100V2_Batt1_V','B3MB_100V2_Bus_V'}, ...
      'B3MB 100V2 Batt Volts 100V2', ...
      'Volts 100V2', ...
      {'B1V','BusV'}, ...
      varargin{:} );
