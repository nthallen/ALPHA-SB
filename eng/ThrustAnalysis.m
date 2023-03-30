%%
run = '221115.1';
datadir = SCoPEx_Data_Dir;
D1 = load_eng_mat(datadir, run, 'scopexeng_1');
D2 = load_eng_mat(datadir, run, 'scopexeng_2');
D10 = load_eng_mat(datadir, run, 'scopexeng_10');

[~, ~, P2log_dT] = cranetest2_timeoffsets;
P2log_dT = P2log_dT + 24*3600;
D1.T = D1.T-P2log_dT;
D2.T = D2.T-P2log_dT;
D10.T = D10.T-P2log_dT;
% Thrust at 10 Hz
[Thrust, dThrust, ThrustCmd] = Thrust_10Hz(D1, D2, D10);
%%
ax = nsubplots(5);
plot(ax(1),D10.T,Thrust); ylabel(ax(1),'Thrust');
plot(ax(2),D10.T,dThrust); ylabel(ax(2),'dThrust');
plot(ax(3),D10.T,D10.heading,D1.T,D1.Nav_Course); ylabel(ax(3),'heading');
plot(ax(4),D10.T,D10.angular_velocity_z); ylabel(ax(4),'\omega_z');
semilogy(ax(5),D1.T,D1.Nav_PGain,D1.T,D1.Nav_DGain); ylabel(ax(5),'Gains');
cleanup_subplots(ax);
%%
[Course,Kp,Kd] = Course_10Hz(D1,D10);
HdErr = (Course - D10.heading) * pi/180; % rad
% Should be scaled by sample rate (*10), but is not in the instrument.
% Scale is made up in Kd
dHdErr = [0; diff(HdErr)];
PThrust = clamp_abs(Kp .* HdErr,40);
DThrust = clamp_abs(Kd .* dHdErr,40);
dThrust_dt = [0; diff(dThrust)]*10; % 10 Hz
%%
ax = nsubplots(3);
plot(ax(1),D10.T,PThrust,D10.T,DThrust, ...
  D10.T,clamp_abs(PThrust+DThrust,40),D10.T,dThrust);
legend(ax(1),'P','D','sum','actual');
plot(ax(2),D10.T,HdErr); ylabel(ax(2),'Heading Error');
plot(ax(3),D10.T,dHdErr); ylabel(ax(3),'dError');
cleanup_subplots(ax);
%%
ax = nsubplots(3);
plot(ax(1),D10.T,D10.heading,D1.T,D1.Nav_Course); ylabel(ax(1),'heading');
plot(ax(2),D10.T,Thrust,D10.T,dThrust); ylabel(ax(2),'Thrust');
plot(ax(3),D10.T,dThrust_dt); ylabel(ax(3),'dThrust/dt');
cleanup_subplots(ax);
%%
% Look at regions bordered by changes in:
%  Course, ThrustCmd, Kp, Kd and Nav_Status
% considering only regions where Nav_Status == PID (1) and the duration is
% more than some minimum (4 minutes?)
NavStatus = NavStat_10Hz(D1,D10);
chgpts = find((diff(Course) ~= 0) | (diff(ThrustCmd) ~= 0) ...
  | (diff(Kp) ~= 0) | (diff(Kd) ~= 0) | (diff(NavStatus) ~= 0));
starts = [1;chgpts+1];
ends = [chgpts;length(Course)];
dur = (D10.T(ends)-D10.T(starts))/60;
OK = NavStatus(starts) == 1 & dur > 1.5;
X = 1:length(starts);
figure; plot(X(OK),dur(OK),'*',X(~OK),dur(~OK),'.');
grid on;
ylabel('Minutes');
title('Region Durations');
legend('accept','reject');
%%
% Now I want to look at:
%   Course Error (mean, std)
%   dThrust (mean, std)
%   angular velocity (mean, std)
%   d(dThrust)/dt (mean, std)
% First crudely eliminate the initial transients
OKstarts = starts(OK);
OKends = ends(OK);
settled = zeros(length(OKstarts));
[T_mean,~] = bin_data(D10.T,OKstarts,OKends);
% figure;
for i=1:length(T_mean)
  xi = OKstarts(i):OKends(i);
  zcrossing = find(diff(sign(HdErr(xi))),1);
  if isempty(zcrossing)
    settled(i) = xi(1);
  else
    settled(i) = xi(zcrossing);
  end
%   plot(D10.T(xi),HdErr(xi),D10.T(settled(i)),HdErr(settled(i)),'*r');
%   pause;
end
%%
[T_mean,~] = bin_data(D10.T,settled,OKends);
[HdErr_mean,HdErr_std] = bin_data(HdErr*180/pi,settled,OKends);
plot_mean_std(T_mean,HdErr_mean,HdErr_std,'Heading Error maintaining heading, deg');
%%
[dThrust_mean,dThrust_std] = bin_data(dThrust,settled,OKends);
plot_mean_std(T_mean,dThrust_mean,dThrust_std,'Differential Thrust maintaining heading, N');
% Plot RMS to see if it is any different
% A bit different, but not significantly
% [dT2,~] = bin_data(dThrust.^2,settled,OKends);
% hold on
% plot(T_mean,sqrt(dT2),'x');
% hold off
%%
[dThrust_dt_mean,dThrust_dt_std] = bin_data(dThrust_dt,settled,OKends);
plot_mean_std(T_mean,dThrust_dt_mean,dThrust_dt_std,'dThrust/dt maintaining heading, N/s');
%% This one isn't interesting
[T_mean_st,~] = bin_data(D10.T,OKstarts,settled);
[HdErr_st_mean,HdErr_st_std] = bin_data(HdErr*180/pi,OKstarts,settled);
plot_mean_std(T_mean_st,HdErr_st_mean,HdErr_st_std,'Heading Error changing course, deg');
%%
[dThrust_st_mean,dThrust_st_std] = bin_data(dThrust,OKstarts,settled);
plot_mean_std(T_mean_st,abs(dThrust_st_mean),dThrust_st_std,'Differential Thrust changing course, N');
% Plot RMS to see if it is any different
% A bit different, but not significantly
% [dT2,~] = bin_data(dThrust.^2,OKstarts,settled);
% hold on
% plot(T_mean_st,sqrt(dT2),'x');
% hold off
%%
HdErr_st_max = bin_max_data(abs(HdErr),OKstarts,settled)*180/pi;
figure;
plot(T_mean_st,HdErr_st_max,'*');
title('Max abs HdErr changing course, N');
%%
dThrust_st_max = bin_max_data(abs(dThrust),OKstarts,settled);
figure;
plot(T_mean_st,dThrust_st_max,'*');
title('Max abs dThrust changing course, N');
%%
figure;
plot(ThrustCmd(OKstarts),dThrust_st_max,'*');
title('Max abs dThrust vs ThrustCmd changing course, N');
%%
figure;
scatter(HdErr_st_max,dThrust_st_max,30,ThrustCmd(OKstarts),"filled");
colorbar;
title('Max abs dThrust vs Course Change, N');
%%
[dThrust_dt_st_mean,dThrust_dt_st_std] = bin_data(dThrust_dt,OKstarts,settled);
plot_mean_std(T_mean_st,dThrust_dt_st_mean,dThrust_dt_st_std,'dThrust/dt changing course, N/s');
%%
dThrust_dt_st_max = bin_max_data(abs(dThrust_dt),OKstarts,settled);
figure;
plot(T_mean_st,dThrust_dt_st_max,'*');
title('Max abs dThrust/dt changing course, N');
%%
figure;
plot(ThrustCmd(OKstarts),dThrust_dt_st_max,'*');
%%
function D = load_eng_mat(datadir, run, file)
% D = load_eng_mat(datadir, run, file);
path = [datadir filesep run filesep file '.mat'];
try
  D = load(path);
catch
  fprintf(1,'Unable to load %s', path);
  D = [];
end
if ~isempty(D)
  Tvar = [ 'T' file ];
  if isfield(D,Tvar) && ~isfield(D,'T')
    D.T = time2d(D.(Tvar));
  end
end
end

function Th = RPM_to_Thrust(RPM)
Th = 8E-5 * abs(RPM).^2.1625;
end

function [Thrust, dThrust, ThrustCmd] = Thrust_10Hz(D1, D2, D10)
LRPM = interp1(D2.T,D2.PMC_Left_RPM,D10.T);
LThrust = RPM_to_Thrust(LRPM);
RRPM = interp1(D2.T,D2.PMC_Right_RPM,D10.T);
RThrust = RPM_to_Thrust(RRPM);
Thrust = LThrust + RThrust;
dThrust = LThrust - RThrust;
if nargout > 2
  ThrustCmd = interp1(D1.T,D1.Nav_Thrust_pct,D10.T,'nearest','extrap');
end
end

function [Course,Kp,Kd] = Course_10Hz(D1,D10)
Course = interp1(D1.T,D1.Nav_Course,D10.T,'nearest','extrap');
Kp = interp1(D1.T,D1.Nav_PGain,D10.T,'nearest','extrap');
Kd = interp1(D1.T,D1.Nav_DGain,D10.T,'nearest','extrap');
end

function NavStatus = NavStat_10Hz(D1, D10)
NavStatus = interp1(D1.T, D1.Nav_Status, D10.T,'nearest','extrap');
end

function [data_mean,data_std] = bin_data(data,starts,ends)
  data_mean = zeros(length(starts),1);
  data_std = data_mean;
  for i=1:length(starts)
    y = data(starts(i):ends(i));
    data_mean(i) = mean(y);
    data_std(i) = std(y);
  end
end

function data_max = bin_max_data(data,starts,ends)
  data_max = zeros(length(starts),1);
  for i=1:length(starts)
    y = data(starts(i):ends(i));
    data_max(i) = max(y);
  end
end

function clamped = clamp_abs(Y, limit)
clamped = Y;
clamped(Y>limit) = limit;
clamped(Y<-limit) = -limit;
end

function cleanup_subplots(ax)
set(ax(2:2:end),'YAxisLocation','Right');
set(ax(1:end-1),'XTickLabel',[]);
linkaxes(ax,'x');
end

function plot_mean_std(T_mean,data_mean,data_std,plot_title)
figure;
% errorbar(T_mean,HdErr_mean,HdErr_std);
plot(T_mean,data_mean,'.',T_mean,data_std,'*');
grid on;
title(sprintf('%s by region', plot_title));
xlabel('Time');
legend('mean','std');
end