function pchgpbmbsbv(varargin)
% pchgpbmbsbv( [...] );
% B3MB Spread Batt 28V
h = timeplot({'B3MB_28V_Batt_V_mean','B3MB_28V_Batt_V_min','B3MB_28V_Batt_V_max'}, ...
      'B3MB Spread Batt 28V', ...
      'Batt 28V', ...
      {'mean','min','max'}, ...
      varargin{:} );
