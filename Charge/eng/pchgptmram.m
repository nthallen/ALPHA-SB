function pchgptmram(varargin)
% pchgptmram( [...] );
% T Mbase RAM
h = timeplot({'memused'}, ...
      'T Mbase RAM', ...
      'RAM', ...
      {'memused'}, ...
      varargin{:} );
