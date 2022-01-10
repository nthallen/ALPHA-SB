function pscopexmpmclgg(varargin);
% pscopexmpmclgg( [...] );
% PMC Left G Gains
h = timeplot({'PMC_Left_VL_Kp','PMC_Left_VL_Ki','PMC_Left_VL_Kd','PMC_Left_TCL_Kp','PMC_Left_TCL_Ki'}, ...
      'PMC Left G Gains', ...
      'Gains', ...
      {'PMC\_Left\_VL\_Kp','PMC\_Left\_VL\_Ki','PMC\_Left\_VL\_Kd','PMC\_Left\_TCL\_Kp','PMC\_Left\_TCL\_Ki'}, ...
      varargin{:} );