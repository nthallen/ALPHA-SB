%%
% runsdir = SCOPEX_DATA_DIR;
% base = 'scopexeng_1';
% filename = [runsdir filesep run filesep base '.mat'];
% S1 = load(filename);
% S1.T = time2d(S1.(['T' base]));
run = '230929.3';
S1 = load_data(run,'_Cal');
D = collect_vars(S1,'Batt1_V');
S2 = load_data(run,'_TMC_Cal');
D2 = collect_vars(S2,'Batt1_V');
ax = nsubplots(3);
plot(ax(1),S1.T,D.data);
plot(ax(2),S2.T,D2.data);
plot(ax(3),D.X,D.std,'.',D2.X,D2.std,'.');

function D = collect_vars(S, name)
  D.data = zeros(size(S.T,1),8);
  for i=1:8
    varname = sprintf('B3MB_100V%d_%s',i,name);
    D.data(:,i) = S.(varname);
  end
  D.std = sort(std(D.data,[],2));
  D.X = (1:length(S.T))*100/length(S.T);
  D.filename = S.filename;
end

function S = load_data(run, suffix)
  if nargin < 2
    suffix = '';
  end
  runsdir = SCOPEX_DATA_DIR;
  base = 'scopexeng_1';
  filename = [runsdir suffix filesep run filesep base '.mat'];
  S = load(filename);
  S.T = time2d(S.(['T' base]));
  S.filename = filename;
end

