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
chgA = load_charge('221018.1',2,[0,0],[0,102.45]);
chgB = load_charge('230620.2',2,[0],[0]);
chgC = load_charge('230725.1',2,[0],[0]);
chgD = load_charge('230725.2',2,[0.547-.063],[0]);
chgE = load_charge('231116.1',1,[2.143 1.373],[101,102.5]);
chgF = load_charge('231213.1',1,3.994+0.13,102.5);

plot_charging({chgA,chgB,chgC,chgD,chgE,chgF},0);
%%
plot_charging({chgA,chgB,chgC,chgD,chgE,chgF},1);
%%
[allV,allE] = generate_lookup({chgA,chgB,chgC,chgD,chgE,chgF});
allE = allE - 0.6745; % arbitrary 0% poin
allpct = interp1([0 max(allE)],[0 100],allE,'linear','extrap');
save V100gauge.mat allV allE allpct
%%
figure; plot(allV,allpct); grid;
xlabel('Charging Voltage');
ylabel('Energy Percentage');
%%
eval_OL(chgA,1,chgB,1);
eval_OL(chgB,1,chgC,1);
eval_OL(chgA,1,chgD,1);
eval_OL(chgA,1,chgE,1);
eval_OL(chgA,1,chgE,2);
eval_OL(chgA,2,chgE,2);
eval_OL(chgA,2,chgF,1);
eval_OL(chgE,2,chgF,1);
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
function V = chging_vector(chg,i,wo_ol)
starts = find(diff(chg.charging)>0)+1;
ends = find(diff(chg.charging)<0);
assert(length(starts) == length(ends));
assert(all(ends>starts));
V = (1:length(chg.charging))';
V = V>=starts(i) & V<=ends(i);
if wo_ol && chg.WarmupV(i) > 0
  V = V & chg.chgV > chg.WarmupV(i);
end
end

function eval_OL(chgA,Ai,chgB,Bi)
% Ai is index of charging region
VA = chging_vector(chgA,Ai,0);
VB = chging_vector(chgB,Bi,0);
ax = eval_overlap(chgA.chgV(VA),chgA.chgE(VA),chgB.chgV(VB),chgB.chgE(VB));
title(ax(1),sprintf('%s[%d] vs %s[%d]',chgA.run,Ai,chgB.run,Bi));
end

function ax = eval_overlap(V1,E1,V2,E2)
% Evaluate overlap based on common chgV values and difference between chgE
AV = unique(V1);
BV = unique(V2);
CV = interp1(AV,AV,BV,'nearest');
CV = CV(CV==BV); % Common voltages
assert(~isempty(CV));
AVV = (interp1(CV,CV,V1,'nearest') == V1);
AVI = interp1(CV,1:length(CV),V1(AVV),'nearest');
AVE = E1(AVV);
AE = zeros(size(CV));
BVV = (interp1(CV,CV,V2,'nearest') == V2);
BVI = interp1(CV,1:length(CV),V2(BVV),'nearest');
BVE = E2(BVV);
BE = zeros(size(CV));
for i=1:length(CV)
  AE(i) = mean(AVE(AVI==i));
  BE(i) = mean(BVE(BVI==i));
end
figure;
ax = [ nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),CV,AE,'.',CV,BE,'.');
plot(ax(2),CV,BE-AE,'.');
grid(ax(2),'on');
linkaxes(ax,'x');
end

function mM = min_max(x)
mM = [ min(x) max(x) ];
end

function chg = load_charge(run,Escale,Eoffsets,WarmupV)
chg.run = run;
chg.D = load(['C:\cygwin64\home\scopex\charge\MAT\' run '\chgeng_1.mat']);
chg.T = time2d(chg.D.Tchgeng_1);
chg.chgV = chg.D.MPSLd_V_disp;
chg.chgI = chg.D.MPSLd_I_disp;
chg.chgW = chg.chgV.*chg.chgI;
chg.chgE = Escale*cumsum(chg.chgW)/3600/1000; % KWH
chg.WarmupV = WarmupV;
assert(length(Eoffsets) == length(WarmupV));
chg.charging = chg.chgW > 0;
starts = find(diff(chg.charging)>0)+1;
ends = find(diff(chg.charging)<0);
assert(length(starts) == length(ends));
assert(all(ends>starts));
assert(length(starts) == length(Eoffsets));
for i = 1:length(starts)
  s = starts(i);
  e = ends(i);
  chg.chgE(s:e) = chg.chgE(s:e) + Eoffsets(i);
end
end

function plot_charging(chgs,wo_ol)
n_cr = 0;
for i=1:length(chgs)
  chg = chgs{i};
  n_cr = n_cr + length(chg.WarmupV);
end

figure;
labels = cell(n_cr,1);
cri = 1;
for i=1:length(chgs)
  chg = chgs{i};
  for j = 1:length(chg.WarmupV)
    CV = chging_vector(chg,j,wo_ol)';
    plot(chg.chgV(CV),chg.chgE(CV),'.');
    hold on;
    labels{cri} = sprintf('%s[%d]',chg.run,j);
    cri = cri+1;
  end
end
ylabel('KWH');
xlabel('Charging Voltage');
legend(labels,'location','northwest');
grid;
end

%%
function [chgV,chgE] = generate_lookup(chgs)
 n_pts = 0;
 for i=1:length(chgs)
   chg = chgs{i};
   for j = 1:length(chg.WarmupV)
     n_pts = n_pts + sum(chging_vector(chg,j,1));
   end
 end
 allV = zeros(n_pts,1);
 allE = zeros(n_pts,1);
 curri = 1;
 for i=1:length(chgs)
   chg = chgs{i};
   for j = 1:length(chg.WarmupV)
     V = chging_vector(chg,j,1);
     np = sum(V);
     allV(curri:curri+np-1) = chg.chgV(V);
     allE(curri:curri+np-1) = chg.chgE(V);
     curri = curri+np;
   end
 end
 assert(curri == n_pts+1);
 chgV = unique(allV);
 n_bins = length(chgV);
 allI = interp1(chgV,(1:n_bins)',allV,'nearest');
 chgE = zeros(n_bins,1);
 for i=1:n_bins
   chgE(i) = mean(allE(allI==i));
 end
 end
