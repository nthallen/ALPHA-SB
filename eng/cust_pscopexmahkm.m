function cust_pscopexmahkm(h)
% cust_pscopexmahkm(h)
% Customize plot created by pscopexmahkm

% pscopexmahkm's definition:

% function pscopexmahkm(varargin);
% % pscopexmahkm( [...] );
% % Asc HK Mode
% h = timeplot({'AscMode'}, ...
%       'Asc HK Mode', ...
%       'Mode', ...
%       {'AscMode'}, ...
%       varargin{:} );

% Example customizations include:
%   set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
redraw_digital_status(h,{'***','Idle','Moving','RecovErr','UnrecovErr'});
