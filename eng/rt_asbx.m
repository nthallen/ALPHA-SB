function dfs = rt_asbx(varargin)
dfs = rt_asb(varargin{:});
dfs.start_tab('Custom');
dfs.start_col;
dfs.plot('gondola','label','Gondola','vars',{'east_m', 'north_m', 'heading', 'Nav_Course', 'Track', 'velocity_forward'}, 'custom_axis', @gondola);
dfs.end_col;
dfs.end_tab;
if nargout > 0
  dfs_out = dfs;
else
  dfs.resize();
end
