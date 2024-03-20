function pchgpbmbsbatt_100v(varargin);
% pchgpbmbsbatt_100v( [...] );
% B3MB Spread Batt 100V
h = timeplot({'B3MB_100V_Batt_V_mean','B3MB_100V_Batt_V_min','B3MB_100V_Batt_V_max'}, ...
      'B3MB Spread Batt 100V', ...
      'Batt 100V', ...
      {'mean','min','max'}, ...
      varargin{:} );
