function fig = gscopexmgnsshk(varargin);
% gscopexmgnsshk(...)
% GNSS HK
ffig = ne_group(varargin,'GNSS HK','pscopexmgnsshks','pscopexmgnsshkf','pscopexmgnsshkd','pscopexmgnsshkstd','pscopexmgnsshkstale');
if nargout > 0 fig = ffig; end
