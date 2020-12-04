%%
close all
clear all
clc

% Setup the figure
fig = figure;
set(fig,'color',[.8 .8 1]);
dfs = data_fields(fig,'h_leading', 5, 'txt_fontsize', 12);
%
%dfs.h_padding = 0;
rec1 = 'scopexeng_1';
rec2 = 'scopexeng_2';
dfs.start_col();
dfs.field(rec1,'SysTDrift','%6.3f');
dfs.field(rec1,'CPU_Pct', '%5.1f');
dfs.field(rec1,'memused', '%5.1f');
dfs.field(rec1,'Disk', '%5.1f');
dfs.end_col();
dfs.start_col();
dfs.field(rec2,'PMC_Left_I_Measured','%6.2f');
dfs.field(rec1,'PMC_Left_I_Demand','%6.2f');
dfs.field(rec2,'PMC_Left_RPM','%7.1f');
dfs.field(rec1,'PMC_Left_RPM_Demand','%7.1f');
dfs.field(rec1,'PMC_Left_RPM_SP','%7.1f');
%
dfs.new_graph(rec1, 'CPU_Pct', 'new_fig');
%%
%dfs.new_graph(rec2,'PMC_Left_RPM','new_axes',
%%
% Setup the data connection
dfs.connect('127.0.0.1', 1080);
%%
dfs.disconnect();
close all
clear all
clc
