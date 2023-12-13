%%
% Assumes chgeng_1 has been loaded via ui_chg
% This section looks at total energy during charge:
T = time2d(chgeng_1.Tchgeng_1);
chgV = chgeng_1.MPSLd_V_disp;
chgI = chgeng_1.MPSLd_I_disp;
chgW = chgV.*chgI;
chgE = cumsum(chgW)/3600/1000; % KWH
%%
ax = nsubplots(2);
plot(ax(1),T,chgW);
plot(ax(2),T,chgE);
%%
charging = chgW > 0;
ax = nsubplots(2);
plot(ax(1),chgW(charging));
plot(ax(2),chgE(charging));
%%
figure;
chgN = sum(charging);
chgT = (1:chgN)/3600;
plot(chgT,chgE(charging),'.');
ylabel('KWH');
xlabel('Hours');
grid;
%%
figure;
plot(chgV(charging),chgE(charging),'.');
ylabel('KWH');
xlabel('Charging Voltage');
grid;
%%
figure;
plot(chgV(charging),chgE(charging),'.', ...
  min_max(chgV(charging)), min_max(chgE(charging)));
ylabel('KWH');
xlabel('Charging Voltage');
grid;

%%
% These sections are looking at the repeatability of the charging curves
% for 100V batteries. These were all done with 4 cans
chgA = load_charge('221018.1');
chgB = load_charge('230620.2');
chgC = load_charge('230725.1');
chgD = load_charge('230725.2');
chgD.chgE = chgD.chgE + max(chgC.chgE) - 1.3;
%%
figure;
plot(chgA.chgV(chgA.charging),chgA.chgE(chgA.charging),'.', ...
  chgB.chgV(chgB.charging),chgB.chgE(chgB.charging),'.', ...
  chgC.chgV(chgC.charging),chgC.chgE(chgC.charging),'.', ...
  chgD.chgV(chgD.charging),chgD.chgE(chgD.charging),'.');
ylabel('KWH');
xlabel('Charging Voltage');
legend(chgA.run, chgB.run, chgC.run, chgD.run,'location','northwest');
grid;
%%
% Calculate discharge power rate between C and D
% First confirm the two are in fact contiguous:
% T = [chgC.D.Tchgeng_1; chgD.D.Tchgeng_1];
% dT = diff(T);
% unique(dT) gives just 1, 139 and 311, so yes
% Now identify the end of the first charging period and the start of the
% second:
EOC1 = find(diff(chgC.charging)<0); % It's a single value, so good!
BOC2 = find(diff(chgD.charging)>0); % Also single valued
DischargeHours = (chgD.D.Tchgeng_1(BOC2) - chgC.D.Tchgeng_1(EOC1))/3600; % hours
DischargeEnergy = 1300; % Watt Hours
DischargePower = DischargeEnergy/DischargeHours; % Watts
fprintf(1,'Discharge of %.0f WHrs over %.1f Hours for a rate of %.2f Watts\n', ...
  DischargeEnergy, DischargeHours, DischargePower);
%%
DisPwr = zeros(size(chgC.charging));
DisPwr(EOC1:end) = DischargePower;
DisEnergy = chgC.chgE - cumsum(DisPwr)/3600/1000; % KWH
%%
figure;
ax = [ nsubplot(1,2,1) nsubplot(1,2,2) ];
plot(ax(1), chgC.D.B3MB_100V1_Bus_V(chgC.charging),DisEnergy(chgC.charging),'.', ...
  chgC.D.B3MB_100V1_Bus_V(~chgC.charging),DisEnergy(~chgC.charging),'.');
xlabel(ax(1),'Volts');
ylabel(ax(1),'KWH');
legend(ax(1),'Charging','Discharging','location','northwest');
title(ax(1),chgC.run);
xlim(ax(1),[77 105]);
grid(ax(1),'on');
%
chgC.discharging = ~chgC.charging & chgC.T > max(chgC.T(chgC.charging));
StoredEnergy = 0.25:0.01:1.54;
ChgV = interp1(DisEnergy(chgC.charging), ...
  chgC.D.B3MB_100V1_Bus_V(chgC.charging),StoredEnergy, ...
  'linear','extrap');
DisChgV = interp1(DisEnergy(chgC.discharging), ...
  chgC.D.B3MB_100V1_Bus_V(chgC.discharging),StoredEnergy, ...
  'linear','extrap');
dV = ChgV-DisChgV;
plot(ax(2),dV,StoredEnergy);
% ylabel(ax(2),'Stored KWH');
xlabel(ax(2),'\Delta{}V');
grid(ax(2),'on');
set(ax(2),'YAxisLocation','Right','XAxisLocation','Top');
linkaxes(ax,'y');
%%
%%
function mM = min_max(x)
mM = [ min(x) max(x) ];
end

function chg = load_charge(run)
chg.run = run;
chg.D = load(['C:\cygwin64\home\scopex\charge\MAT\' run '\chgeng_1.mat']);
chg.T = time2d(chg.D.Tchgeng_1);
chg.chgV = chg.D.MPSLd_V_disp;
chg.chgI = chg.D.MPSLd_I_disp;
chg.chgW = chg.chgV.*chg.chgI;
chg.chgE = cumsum(chg.chgW)/3600/1000; % KWH
chg.charging = chg.chgW > 0;
end
