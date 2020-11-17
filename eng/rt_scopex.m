%%
% rt_scopex.m
close all
clear all
clc

% Setup the figure
fig = figure;
set(fig,'color',[.8 .8 1]);
dfs = data_fields(fig,'h_leading', 5, 'txt_fontsize', 12);
rec = 'scopexeng_1';
recf = 'scopexeng_2';
dfs.new_graph(rec, 'CPU_Pct', 'new_fig');
dfs.new_graph(rec, 'PMC_Left_RPM_SP', 'new_fig');
dfs.new_graph(recf, 'PMC_Left_RPM', 'cur_axes', 2, 1);
dfs.new_graph(rec, 'PMC_Left_I_Demand', 'new_axes', 2);
dfs.new_graph(recf, 'PMC_Left_I_Measured', 'cur_axes', 2, 2);
%%
% Setup the data connection
dfs.connect('127.0.0.1', 1080);
%%
dfs.disconnect();
close all
clear all
clc
