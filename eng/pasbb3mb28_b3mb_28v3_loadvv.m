function pasbb3mb28_b3mb_28v3_loadvv(varargin);
% pasbb3mb28_b3mb_28v3_loadvv( [...] );
% B3MB 28V3 Load Volts 28V3
h = timeplot({'B3MB_28V3_Load1_V','USBHub_V','HALSA_V','POPS_V'}, ...
      'B3MB 28V3 Load Volts 28V3', ...
      'Volts 28V3', ...
      {'L1V','L2V','L3V','L4V'}, ...
      varargin{:} );
