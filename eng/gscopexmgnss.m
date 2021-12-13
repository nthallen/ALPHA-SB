function fig = gscopexmgnss(varargin);
% gscopexmgnss(...)
% GNSS
ffig = ne_group(varargin,'GNSS','pscopexmgnsss','pscopexmgnssf','pscopexmgnssd','pscopexmgnssp','pscopexmgnssv','pscopexmgnssh','pscopexmgnssa','pscopexmgnssattitude','pscopexmgnssav','pscopexmgnssstd','pscopexmgnssstale');
if nargout > 0 fig = ffig; end
