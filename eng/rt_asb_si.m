function dfs_out = rt_asb_si(varargin)
dfs = rt_asb(varargin{:});
dfs.set_connection('127.0.0.1', 1411);
dfs.fig.Name = 'SerIn';
if nargout > 0
  dfs_out = dfs;
end
