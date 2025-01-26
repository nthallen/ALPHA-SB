function pchgplots_b3mb_all_100bus_100v(varargin)
% pchgplots_b3mb_all_100bus_100v( [...] );
% B3MB All 100 Bus 100V
h = timeplot({'B3MB_100V1_Bus_V','B3MB_100V2_Bus_V','B3MB_100V3_Bus_V','B3MB_100V4_Bus_V','B3MB_100V5_Bus_V','B3MB_100V6_Bus_V','B3MB_100V7_Bus_V','B3MB_100V8_Bus_V'}, ...
      'B3MB All 100 Bus 100V', ...
      'Bus 100V', ...
      {'B3MB\_100V1\_Bus\_V','B3MB\_100V2\_Bus\_V','B3MB\_100V3\_Bus\_V','B3MB\_100V4\_Bus\_V','B3MB\_100V5\_Bus\_V','B3MB\_100V6\_Bus\_V','B3MB\_100V7\_Bus\_V','B3MB\_100V8\_Bus\_V'}, ...
      varargin{:} );
