function fig = gasbmgnsshk(varargin);
% gasbmgnsshk(...)
% GNSS HK
ffig = ne_group(varargin,'GNSS HK','pasbmgnsshks','pasbmgnsshkf','pasbmgnsshkd','pasbmgnsshkdrift','pasbmgnsshkstd','pasbmgnsshkstale');
if nargout > 0 fig = ffig; end
