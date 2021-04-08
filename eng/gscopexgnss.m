function fig = gscopexgnss(varargin);
% gscopexgnss(...)
% GNSS
ffig = ne_group(varargin,'GNSS','pscopexgnsss','pscopexgnssf','pscopexgnssd','pscopexgnssp','pscopexgnssh','pscopexgnssv','pscopexgnssa','pscopexgnssattitude','pscopexgnssav','pscopexgnssstd','pscopexgnssstale');
if nargout > 0 fig = ffig; end
