%%
% System current analysis
% 100V Load Current Variables: use definitions from scopex.spec
% Compare total load current to total battery current
% Look at balance of power between cans
B100V1.name = '100V1';
B100V1.SN = 101;
B100V1.L3 = 'EngPort100';
B100V1.L4 = 'AscSec1';

B100V2.name = '100V2';
B100V2.SN = 102;
B100V2.L1 = 'AscRes1';
B100V2.L2 = 'AscPri1';

B100V3.name = '100V3';
B100V3.SN = 5;
B100V3.L1 = 'AscRes2';
B100V3.L2 = 'AscPri2';

B100V4.name = '100V4';
B100V4.SN = 104;
B100V4.L3 = 'EngStbd100';
B100V4.L4 = 'AscSec2';

B100V5.name = '100V5';
B100V5.SN = 105;
B100V6.name = '100V6';
B100V6.SN = 106;
B100V7.name = '100V7';
B100V7.SN = 103;
B100V8.name = '100V8';
B100V8.SN = 110;

Cans = {B100V1, B100V2, B100V3, B100V4, B100V5, B100V6, B100V7, B100V8 }';
clear B100V1 B100V2 B100V3 B100V4 B100V5 B100V6 B100V7 B100V8;
%%
% Collect the calibration data for each can
% Steps during tests
Vtst  = [20, 40, 60, 80, 100];
Itst  = [0.0 0.05 0.1 0.2 0.5 1.0 2.0 5.0 7.5 9.5];
num_meas  = 20;    % number of measurements at any step for noise meas.
VVtst = reshape(ones(num_meas,1)*Vtst,[],1);
VVV = reshape( ...
  [zeros(3,1); ones(num_meas-5,1); zeros(2,1)]*ones(size(Vtst)),[],1) > 0;
VItst = reshape(ones(num_meas,1)*Itst,[],1);
% Discard the low current test points, because some channels saturate
VVI = reshape( ...
  [zeros(3,1); ones(num_meas-5,1); zeros(2,1)] * ...
  [zeros(1,4) ones(1,length(Itst)-4)],[],1) > 0;

BattV = zeros(2,4,8);
BattI = zeros(2,4,8);
LoadV = zeros(2,4,8);
LoadI = zeros(2,4,8);
BusV  = zeros(2,4,8);
BattVOK = zeros(8,4) < 1;
BattIOK = zeros(8,4) < 1;
LoadVOK = zeros(8,4) < 1;
LoadIOK = zeros(8,4) < 1;
BusVOK = zeros(8,4) < 1;
for i=1:length(Cans)
  can = Cans{i};
  % Get Calibration Data
  folder = 'c:\cygwin64\home\scopex\MAT\B3MB\';
  calfname = sprintf('%sB3MB_cal_data_SN%03d_202308*.mat', folder, can.SN);
  files = dir(calfname);
  calfname = [ files(1).folder filesep files(1).name ];
  CD = load(calfname);
  % look at battery coeffs
  % BattV = varnum 2
  % BattI = varnum 7
  % Vcoefs     = zeros(2, num_loads, num_vars);
  % So for BattV, I want to look at Vcoefs(:,:,2)
  % BattV(1,:) should all be close to 1 (gain)
  % BattV(2,:) should all be close to 0 (offset)
  BattV(:,:,i) = CD.Vcoefs(:,:,2);
  BattI(:,:,i) = CD.Icoefs(:,:,7);
  LoadV(:,:,i) = CD.Vcoefs(:,:,3);
  LoadI(:,:,i) = CD.Icoefs(:,:,8);
  BusV(:,:,i)  = CD.Vcoefs(:,:,5);
  BattVOK(i,:) = check_cal(BattV(:,:,i));
  BattIOK(i,:) = check_cal(BattI(:,:,i));
  LoadVOK(i,:) = check_cal(LoadV(:,:,i));
  LoadIOK(i,:) = check_cal(LoadI(:,:,i));
  BusVOK(i,:)  = check_cal(BusV(:,:,i));
  can.CalBattV = fit_multiple_loads(VVtst,CD.Vmeas_vars,2,BattVOK(i,:),VVV);
  can.CalBusV  = fit_multiple_loads(VVtst,CD.Vmeas_vars,5,BattVOK(i,:),VVV);
  can.CalBattI = fit_multiple_loads(VItst,CD.Imeas_vars,7,BattIOK(i,:),VVI);
  for loadnum=1:4
    ld = sprintf('L%d', loadnum);
    if ~isfield(can, ld)
      can.(ld) = sprintf('B3MB_%s_Load%d', can.name, loadnum);
    end
  end
  Cans{i} = can;
end
clear loadnum ld ldV ldI ldW can i
%%
% Calculate power for each battery
% Calculate power for each load
% Calculate load power for each can
% Each can has
%    B3MB_$(name)_Batt1_I and Batt1_V
%   4 Loads, each with I and V
%   The default name for loads is B3MB_$(name)_Load$(load)_I,V, but the
%   lengthy part is replaced with the short name if provided.
Names = cell(length(Cans),1);
for i=1:length(Cans)
  can = Cans{i};
  % % Get Calibration Data
  % folder = 'c:\cygwin64\home\scopex\MAT\B3MB\';
  % calfname = sprintf('%sB3MB_cal_data_SN%03d_202308*.mat', folder, can.SN);
  % files = dir(calfname);
  % calfname = [ files(1).folder filesep files(1).name ];
  % CD = load(calfname);
  Names{i} = can.name;
  BattV = sprintf('B3MB_%s_Batt1_V', can.name);
  BattI = sprintf('B3MB_%s_Batt1_I', can.name);
  can.BattV = (scopexeng_1.(BattV)-can.CalBattV(2))/can.CalBattV(1);
  can.BattI = (scopexeng_1.(BattI)-can.CalBattI(2))/can.CalBattI(1);
  can.BattW = can.BattV .* can.BattI;
  can.BattWH = cumsum(can.BattW)/3600;
  can.BattKWH = sum(can.BattW)/3600/1000;
  for loadnum=1:4
    ld = sprintf('L%d', loadnum);
    % if ~isfield(can, ld)
    %   can.(ld) = sprintf('B3MB_%s_Load%d', can.name, loadnum);
    % end
    ldV = sprintf('%s_V', can.(ld));
    ldI = sprintf('%s_I', can.(ld));
    ldW = sprintf('L%dW', loadnum);
    can.(ldW) = scopexeng_1.(ldV).*scopexeng_1.(ldI);
  end
  can.LW = can.L1W + can.L2W + can.L3W + can.L4W;
  can.LWH = cumsum(can.LW)/3600; % WH
  can.LKWH = sum(can.LW)/3600/1000; % scalar
  Cans{i} = can;
end
clear loadnum ld ldV ldI ldW BattI BattV can i
%%
% Correct for saturated Battery currents:
T = scopexeng_1.T;
Imin = zeros(length(Cans),1);
satpct = zeros(length(Cans),1);
for i=1:length(Cans)
  I = Cans{i}.BattI;
  Imin(i) = min(I);
  sat = I < Imin(i) + 2.5*.002;
  satpct(i) = sum(sat)/length(sat);
end
saturated = satpct >= 0.01;
Idflt = zeros(size(T));
for i=find(~saturated)'
  Idflt = Idflt + Cans{i}.BattI;
end
Idflt = Idflt / sum(~saturated);
for i=find(saturated)'
  can = Cans{i};
  I = can.BattI;
  sat = I < Imin(i) + 2.5*.002;
  figure;
  plot(Idflt(~sat),I(~sat),'.'); grid;
  title(sprintf('Can %d BattI vs Idflt',i));
  % fitsat = polyfit(Idflt(~sat),I(~sat),1);
  % fprintf('Can %d fitsat: ',i); disp(fitsat);
  % can.BattI(sat) = polyval(fitsat,Idflt(sat));
  can.BattI(sat) = Idflt(sat);
  can.BattW = can.BattV .* can.BattI;
  can.BattWH = cumsum(can.BattW)/3600;
  can.BattKWH = sum(can.BattW)/3600/1000;
  Cans{i} = can;
end
%%
% Look at data for a specific part of the calibration
VarNames = ["SupV" "BatV" "LodV" "PgLV" "BusV" "SupI" "BatI" "LodI" "PgLI"];
i = 2;
loadnum = 4;
folder = 'c:\cygwin64\home\scopex\MAT\B3MB\';
can = Cans{i};
calfname = sprintf('%sB3MB_cal_data_SN%03d_202308*.mat', folder, can.SN);
files = dir(calfname);
calfname = [ files(1).folder filesep files(1).name ];
CD = load(calfname);
VD = squeeze(CD.Vmeas_vars(loadnum,:,:));
ID = squeeze(CD.Imeas_vars(loadnum,:,:));
figure; stackedplot(VD',"DisplayLabel", VarNames, "Title", sprintf('Vmeas vars Can %d Load %d', i, loadnum));
figure; stackedplot(ID',"DisplayLabel", VarNames, "Title", sprintf('Imeas vars Can %d Load %d', i, loadnum));
%%
% Calculate summary data
T = scopexeng_1.T;
BW = zeros(length(T),length(Cans));
BWH = zeros(length(T),length(Cans));
BKWH = zeros(length(Cans),1);
LW = zeros(length(T),length(Cans));
LKWH = zeros(length(Cans),1);
for i=1:length(Cans)
  BW(:,i) = Cans{i}.BattW;
  BWH(:,i) = Cans{i}.BattWH;
  BKWH(i) = Cans{i}.BattKWH;
  LW(:,i) = Cans{i}.LW;
  LKWH(i) = Cans{i}.LKWH;
end
clear i
%%
figure;
area(T,BW);
xlabel('Seconds');
ylabel('Watts');
title('Battery Power by Can');
legend(Names);
%%
figure;
area(T,LW);
xlabel('Seconds');
ylabel('Watts');
title('Load Power by Can');
legend(Names);
%%
figure;
bar(BKWH);
title('Total Battery Energy Consumed by Can');
grid;
ylabel('KWH');
%%
figure;
bar(LKWH);
title('Total Load Energy Consumed by Can');
grid;
ylabel('KWH');
%%
function isok = check_cal(D)
% isok = check_cal(D)
% D is a 2xN array where I expect the first row to be close to 1 and the
% second row to be close to zero
% isok will be a logical row vector matching the number of columns in D
isok = D(1,:) > 0.9 & D(1,:) < 1.2 & D(2,:); % > -0.3 & D(2,:) < 0.3;

end

function V = fit_multiple_loads(X,meas,varnum,good_loads,VV)
  nlds = sum(good_loads);
  x = reshape((X(VV)*ones(1,nlds))',[],1);
  y = reshape(meas(good_loads,varnum,VV),[],1);
  V = polyfit(x,y,1);
  % xfit = [min(x) max(x)];
  % figure; plot(x,y,'.',xfit, polyval(V,xfit));
  % title(sprintf('Varnum %d',varnum));
end
