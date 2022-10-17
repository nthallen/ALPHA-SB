function cust_pscopexmgnssh(h)
% cust_pscopexmgnssh(h)
% Customize plot created by pscopexmgnssh

% pscopexmgnssh's definition:

% function pscopexmgnssh(varargin);
% % pscopexmgnssh( [...] );
% % GNSS Heading
% h = timeplot({'Track','heading','Nav_Course'}, ...
%       'GNSS Heading', ...
%       'Heading', ...
%       {'Track','heading','Nav\_Course'}, ...
%       varargin{:} );

% Example customizations include:
%   set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);

% Temporarily hide Track, since it is meaningless until flight
% (Except in simulation!)
%h(1).YData = h(1).YData*NaN;