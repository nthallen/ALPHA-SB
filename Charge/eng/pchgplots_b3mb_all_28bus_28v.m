function pchgplots_b3mb_all_28bus_28v(varargin)
% pchgplots_b3mb_all_28bus_28v( [...] );
% B3MB All 28 Bus 28V
h = timeplot({'B3MB_28V1_Bus_V','B3MB_28V2_Bus_V','B3MB_28V3_Bus_V'}, ...
      'B3MB All 28 Bus 28V', ...
      'Bus 28V', ...
      {'V1','V2','V3'}, ...
      varargin{:} );
