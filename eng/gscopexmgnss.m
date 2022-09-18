function fig = gscopexmgnss(varargin);
% gscopexmgnss(...)
% GNSS
ffig = ne_group(varargin,'GNSS','pscopexmgnsss','pscopexmgnssf','pscopexmgnssd','pscopexmgnssll','pscopexmgnssa','pscopexmgnssp','pscopexmgnssv','pscopexmgnssh','pscopexmgnssaccel','pscopexmgnssattitude','pscopexmgnssav','pscopexmgnssstd','pscopexmgnssstale');
if nargout > 0 fig = ffig; end
