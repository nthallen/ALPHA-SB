function pasbmgnsshkdrift(varargin);
% pasbmgnsshkdrift( [...] );
% GNSS HK Drift
h = timeplot({'nav_drift'}, ...
      'GNSS HK Drift', ...
      'Drift', ...
      {'nav\_drift'}, ...
      varargin{:} );
