function fig = gasbmgnss(varargin);
% gasbmgnss(...)
% GNSS
ffig = ne_group(varargin,'GNSS','pasbmgnssll','pasbmgnssa','pasbmgnssp','pasbmgnssv','pasbmgnsst','pasbmgnssaccel','pasbmgnssattitude','pasbmgnssh','pasbmgnssav');
if nargout > 0 fig = ffig; end
