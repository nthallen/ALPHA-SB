function cust_pscopexmns(h)
% cust_pscopexmns(h)
% Customize plot created by pscopexmns

% pscopexmns's definition:

% function pscopexmns(varargin);
% % pscopexmns( [...] );
% % Nav Status
% h = timeplot({'Nav_Status'}, ...
%       'Nav Status', ...
%       'Status', ...
%       {'Nav\_Status'}, ...
%       varargin{:} );

% Example customizations include:
% set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
status = { 'Idle', 'PID', 'Fail', 'FF\_Init', 'FF\_Pause', ...
           'FF\_Done', 'Port1', 'Stbd1', 'Port2', 'Stbd2' };
redraw_digital_status(h, status);

% Input = h.YData;
% U = unique(Input);
% if length(U) > 1
%   offset = 1-min(U);
%   V = interp1(U,1:length(U),min(U):max(U),'nearest')';
%   SV = V(Input+offset);
%   h.YData = SV;
%   % plot(ax(2),T1(T1V),SV,'.');
%   % set(ax(2),'YAxisLocation','Right','XTickLabels',[]);
% else
%   h.YData = ones(size(h.YData));
% end
% ax = get(h(1),'parent');
% set(ax,'YTick',1:length(U),'YTickLabels', status(U+1),'YLim',[0.9 length(U)+0.1]);
