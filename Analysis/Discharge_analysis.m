%%
% Discharge Analysis
runs1 = {
  '231117.1'
  '231121.1'
  '231122.1'
  '231122.2'
  '231201.1'
  '231204.1'
  '231213.1'
  };
runs2 = {
  '231219.1'
  '231227.1'
  '240102.1'
  '240107.1'
  '240113.1'
  '240118.1'
};
T0s = [5.86 0];

runsets = { runs1 runs2 };
figure;
for ri = 1:length(runsets)
  runs = runsets{ri};
  n_runs = length(runs);
  DCs = cell(n_runs,1);
  %%
  for i=1:n_runs
    DCs{i} = load_discharge(runs{i});
  end
  T0 = DCs{1}.T(1) - T0s(ri)*24*3600;
  for i=1:n_runs
    DCs{i}.Days = (DCs{i}.T - T0)/(24*3600);
  end
  %%
  for i=1:n_runs
    plot(DCs{i}.Days,DCs{i}.V100BusV);
    hold on;
    if i>1
      plot([DCs{i-1}.Days(end) DCs{i}.Days(1)],[DCs{i-1}.V100BusV(end) DCs{i}.V100BusV(1)]);
    end
  end
end

function DC = load_discharge(run)
DC.run = run;
DC.D = load(['C:\cygwin64\home\scopex\charge\MAT\' run '\chgeng_1.mat']);
DC.T = DC.D.Tchgeng_1;
BusVs = zeros(length(DC.T),8);
for i=1:8
  BusVvar = sprintf('B3MB_100V%d_Bus_V',i);
  BusVs(:,i) = DC.D.(BusVvar);
end
DC.V100BusV = mean(BusVs,2);
DC.chgV = DC.D.MPSLd_V_disp;
DC.chgI = DC.D.MPSLd_I_disp;
DC.chgW = DC.chgV.*DC.chgI;
DC.charging = DC.chgW > 0;
chgstart = find(diff(DC.charging)>0,1);
if ~isempty(chgstart)
  chgstart = chgstart-2;
  DC.T = DC.T(1:chgstart);
  DC.V100BusV = DC.V100BusV(1:chgstart);
end
end
