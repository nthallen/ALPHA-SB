function pchgpbmbsbus_100v(varargin)
% pchgpbmbsbus_100v( [...] );
% B3MB Spread Bus 100V
h = timeplot({'B3MB_100V_Bus_V_mean','B3MB_100V_Bus_V_min','B3MB_100V_Bus_V_max'}, ...
      'B3MB Spread Bus 100V', ...
      'Bus 100V', ...
      {'mean','min','max'}, ...
      varargin{:} );
