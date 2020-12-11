function cust_pscopexL100V1I(varargin)
% cust_pscopexL100V1I(varargin)
% Customized plot for load current

vars = {'B3MB_100V1_Load1_I','B3MB_100V1_Load2_I','B3MB_100V1_Load3_I', ...
  'B3MB_100V1_Load4_I','B3MB_100V1_Load1_V','B3MB_100V1_Load2_V', ...
  'B3MB_100V1_Load3_V','B3MB_100V1_Load4_V'};
ttl = 'B3MB 100V1 Load Amps';
ylab = 'Amps';
leg = {'L1','L2','L3','L4'};
minvals = '[ .6, 0, .3, 0 ]';

pat = [ getrundir filesep '*eng*.mat' ];
reqd = findvar( pat, vars{:});
% Should check that all the vars from from the same file
args = ne_args(varargin{:});
n_args = length(vars)/2;
n_plots = 0;
[~,ax] = ne_setup(reqd',args);
p = ['stacked_load_current(' minvals ','];
for i = 1:n_args
  [ ref, Tref ] = ne_varref( vars, reqd, i );
  [ refV, ~ ] = ne_varref( vars, reqd, i+n_args);
  if n_plots == 0
    p = [ p Tref ];
  end
  p = [ p ',' ref ',' refV ',''' args.linetype, '''' ];
  n_plots = n_plots+1;
end
if n_plots > 0
  p = [ p ')' ];
  % fprintf(1,'%s\n',p);
  hh = evalin('base',p);
  grid;
else
  hh = [];
end
if nargout > 0, h = hh; end
if nargout > 1, axx = ax; end
legend(leg);
ne_cleanup( ttl, 'UTC Seconds since Midnight', ylab, '', args, hh );
