function pscopexal(varargin);
% pscopexal( [...] );
% Ascender Limits
h = ne_dstat({
  'AscLimit1', 'AscStatus', 4; ...
	'AscLimit2', 'AscStatus', 4 }, 'Limits', varargin{:} );
