function pscopexmgnssstale(varargin);
% pscopexmgnssstale( [...] );
% GNSS Stale
h = timeplot({'SD_stale','SD_n_reports','SD_nc'}, ...
      'GNSS Stale', ...
      'Stale', ...
      {'SD\_stale','SD\_n\_reports','SD\_nc'}, ...
      varargin{:} );