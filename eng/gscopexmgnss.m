function fig = gscopexmgnss(varargin);
% gscopexmgnss(...)
% GNSS
ffig = ne_group(varargin,'GNSS','pscopexmgnssll','pscopexmgnssa','pscopexmgnssp','pscopexmgnssv','pscopexmgnsst','pscopexmgnssaccel','pscopexmgnssattitude','pscopexmgnssh','pscopexmgnssav');
if nargout > 0 fig = ffig; end
