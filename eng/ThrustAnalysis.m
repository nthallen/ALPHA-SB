%%
run = '221115.1';
datadir = SCoPEx_Data_Dir;
D1 = load_eng_mat(datadir, run, 'scopexeng_1');
D2 = load_eng_mat(datadir, run, 'scopexeng_2');
D10 = load_eng_mat(datadir, run, 'scopexeng_10');

[~, ~, P2log_dT] = cranetest2_timeoffsets;
D1.T = D1.T-P2log_dT;
D2.T = D2.T-P2log_dT;
D10.T = D10.T-P2log_dT;
% Thrust at 10 Hz
[Thrust, dThrust] = Thrust_10Hz(D2, D10);
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

function [Thrust, dThrust] = Thrust_10Hz(D2, D10)
LRPM = interp1(D2.T,D2.PMC_Left_RPM,D10.T);
LThrust = RPM_to_Thrust(LRPM);
RRPM = interp1(D2.T,D2.PMC_Right_RPM,D10.T);
RThrust = RPM_to_Thrust(RRPM);
Thrust = LThrust + RThrust;
dThrust = LThrust - RThrust;
end

function [Course,Kp,Kd] = Course_10Hz(D1,D10)
Course = interp1(D1.T,D1.Nav_Course,D10.T,'nearest','extrap');
Kp = interp1(D1.T,D1.Nav_PGain,D10.T,'nearest','extrap');
Kd = interp1(D1.T,D1.Nav_DGain,D10.T,'nearest','extrap');
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