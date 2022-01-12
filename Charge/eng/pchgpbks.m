function pchgpbks(varargin);
% pchgpbks( [...] );
% B Kd Status
h = ne_dstat({
  'BKd_Output', 'BKd_Status', 0; ...
	'BK_Stale', 'BKd_Status', 1 }, 'Status', varargin{:} );
