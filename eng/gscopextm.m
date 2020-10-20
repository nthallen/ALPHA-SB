function fig = gscopextm(varargin);
% gscopextm(...)
% T Mbase
ffig = ne_group(varargin,'T Mbase','pscopextmtd','pscopextmcpu','pscopextmram','pscopextmd');
if nargout > 0 fig = ffig; end
