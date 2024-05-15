function pasbmgnsshkd(varargin);
% pasbmgnsshkd( [...] );
% GNSS HK Dual
h = ne_dstat({
  'dual_heading_active', 'filter_status', 10 }, 'Dual', varargin{:} );
