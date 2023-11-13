%%
% Time compare
f = figure;
ax = axes(f);
[leg0,dT] = stream_survey(ax, '../../MAT/23092*', 0, 0);
[leg1,dT] = stream_survey(ax, '../../SerIn/MAT/23092*', 1, dT);
[leg2,dT] = stream_survey(ax, '../../Sat/MAT/23092*', 2, dT);
hold(ax,'off');
ylim(ax,[-.25 2.25]);
set(ax,'YTick', 0:2, 'YTickLabels', {'scopex','SerIn','Sat'});
legend([leg0;leg1;leg2],'location','eastoutside');
%%
function [leg,dT] = stream_survey(ax, pattern, Voffset, dT)
  D = dir(pattern);
  for i = 1:length(D)
    S = load_data(D(i).folder, D(i).name, '');
    if dT == 0
      T0 = S.T10(1);
      S.T10 = time2d(S.T10);
      dT = T0 - S.T10(1);
    else
      S.T10 = S.T10-dT;
    end
    dsiT = diff(S.T10);
    Vskip = find(dsiT<0 | dsiT > 200);
    starts = [1;Vskip+1];
    ends = [Vskip; length(S.T10)];
    % lengths = ends-starts+1;
    % Venough = lengths > 20;
    Tvals = NaN * zeros(3*length(starts)-1,1);
    Ovals = NaN * zeros(size(Tvals));
    for j=1:length(starts)
      Voff = [Voffset Voffset]+(j-1)/10;
      Tvals((1:2)+(j-1)*3) = [S.T10(starts(j)) S.T10(ends(j))];
      Ovals((1:2)+(j-1)*3) = Voff;
    end
    plot(ax, Tvals, Ovals, '.-', 'linewidth',3);
    hold(ax,'on');
  end
  grid(ax,'on');
  leg = {D.name}';
end

function S = load_data(basedir, run, stream)
  S.stream = stream;
  S.D10 = load([basedir filesep run filesep 'scopexeng_10.mat']);
  S.hdng = S.D10.heading;
  if S.hdng(1) == 0
    S.hdng(1) = S.hdng(2);
  end
  S.angz = S.D10.angular_velocity_z;
  S.filters = S.D10.filter_status;
  S.T10 = S.D10.Tscopexeng_10;
end
