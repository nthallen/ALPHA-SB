function pasbmdacshks(varargin);
% pasbmdacshks( [...] );
% uDACS HK Scale
h = timeplot({'uDport_fs','uDstbd_fs'}, ...
      'uDACS HK Scale', ...
      'Scale', ...
      {'uDport\_fs','uDstbd\_fs'}, ...
      varargin{:} );