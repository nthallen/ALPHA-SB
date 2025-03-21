function pchgb3mb28_b3mb_28v2_battvv(varargin)
% pchgb3mb28_b3mb_28v2_battvv( [...] );
% B3MB 28V2 Batt Volts 28V2
h = timeplot({'B3MB_28V2_Batt1_V','B3MB_28V2_Batt2_V','B3MB_28V2_Batt3_V','B3MB_28V2_Batt4_V','B3MB_28V2_Bus_V'}, ...
      'B3MB 28V2 Batt Volts 28V2', ...
      'Volts 28V2', ...
      {'B1V','B2V','B3V','B4V','BusV'}, ...
      varargin{:} );
