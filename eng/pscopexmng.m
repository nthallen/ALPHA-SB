function pscopexmng(varargin);
% pscopexmng( [...] );
% Nav Gains
h = timeplot({'Nav_PGain','Nav_IGain','Nav_DGain'}, ...
      'Nav Gains', ...
      'Gains', ...
      {'Nav\_PGain','Nav\_IGain','Nav\_DGain'}, ...
      varargin{:} );
