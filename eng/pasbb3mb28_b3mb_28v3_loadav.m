function pasbb3mb28_b3mb_28v3_loadav(varargin);
% pasbb3mb28_b3mb_28v3_loadav( [...] );
% B3MB 28V3 Load Amps 28V3
h = timeplot({'B3MB_28V3_Load1_I','USBHub_I','HALSA_I','POPS_I'}, ...
      'B3MB 28V3 Load Amps 28V3', ...
      'Amps 28V3', ...
      {'L1I','L2I','L3I','L4I'}, ...
      varargin{:} );
