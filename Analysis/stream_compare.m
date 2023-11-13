%%
% Head-to-head comparison of scopex, scopex.si and scopex.sat data
basedir = '../../MAT';
basedir_si = '../../SerIn/MAT';
basedir_sat = '../../Sat/MAT';
run = '230929.1';
run_si = '230929.1';
run_sat = '230929.1';

sc = load_data(basedir, run, 'SCoPEx');
sc_si = load_data(basedir_si, run_si, 'SerIn');
sc_sat = load_data(basedir_sat, run, 'Sat Modem');
%%
plot_time(sc,sc_si);
plot_time(sc,sc_sat);
%%
plot_heading(sc,sc_si);
plot_heading(sc,sc_sat);
%%
fprintf(1, '\n\nSkip Summary:\n');
show_skips(sc);
show_skips(sc_si);
show_skips(sc_sat, 0.7);
%%
run = '230929.1';
run_si = '230929.1';
run_sat = '230929.1';

sc = load_data(basedir, run, 'SCoPEx');
sc_si = load_data(basedir_si, run_si, 'SerIn');
sc_sat = load_data(basedir_sat, run_sat, 'Sat Modem');
% align_by_heading(sc, sc_si, 200);
% align_by_heading(sc, sc_sat, 200);
%%
run = '230929.2';
run_si = '230929.1';
run_sat = '230929.1';
sc = load_data(basedir, run, 'SCoPEx');
sc_si = load_data(basedir_si, run_si, 'SerIn');
sc_sat = load_data(basedir_sat, run_sat, 'Sat Modem');
  % align_by_heading(sc, sc_si, 200);
  align_by_heading(sc, sc_sat, 200);
%%
  run_si = '230929.2';
  run_sat = '230929.2';
  sc_si = load_data(basedir_si, run_si, 'SerIn');
  sc_sat = load_data(basedir_sat, run_sat, 'Sat Modem');
  % align_by_heading(sc, sc_si, 200);
  align_by_heading(sc, sc_sat, 200);
%%
run = '230929.3';
  sc = load_data(basedir, run, 'SCoPEx');
  align_by_heading(sc, sc_si, 200);
  align_by_heading(sc, sc_sat, 200);
  run_si = '230929.3';
  run_sat = '230929.3';
  sc_si = load_data(basedir_si, run_si, 'SerIn');
  sc_sat = load_data(basedir_sat, run_sat, 'Sat Modem');
  align_by_heading(sc, sc_si, 200);
  align_by_heading(sc, sc_sat, 200);

%%
function S = load_data(basedir, run, stream)
  S.stream = stream;
  S.run = run;
  S.D10 = load([basedir filesep run filesep 'scopexeng_10.mat']);
  S.hdng = S.D10.heading;
  if S.hdng(1) == 0
    S.hdng(1) = S.hdng(2);
  end
  S.angz = S.D10.angular_velocity_z;
  S.filters = S.D10.filter_status;
  S.T10 = time2d(S.D10.Tscopexeng_10);
end

function plot_time(S, T)
  figure;
  XS = 1:length(S.D10.Tscopexeng_10);
  XT = 1:length(T.D10.Tscopexeng_10);
  ax = plot(XS, S.D10.Tscopexeng_10, XT, T.D10.Tscopexeng_10);
  title(sprintf('Time vs Sample for  %s and %s', S.stream, T.stream))
end

function plot_heading(S, T)
  figure;
  plot(S.T10, S.hdng, T.T10, T.hdng);
  title(sprintf('Heading vs Time for  %s and %s', S.stream, T.stream))
end

function show_skips(S, def_skip)
  if nargin < 2
    def_skip = 0.1;
  end
  dsiT = diff(S.T10);
  Vskip = abs(dsiT-def_skip) > 0.01;
  fprintf(1,'Skips for %s (default %.1f)\n', S.stream, def_skip);
  fprintf(1,'%9.2f\n', dsiT(Vskip));
end

function [lag,magpct] = get_lag(u,v)
  % This is like a correlation function, but I will use exact equality
  % rather than the product (and no doubt make it slower)
  % The lag will be the amount that v needs to be shifted relative to u to
  % get the best agreement. We start with v shifted negative so only v(end)
  % overlaps with u(1). Hence the starting candidate lag is 1-length(v).
  % The last candidate lag will be length(u)-1, where u(end) and v(1) are
  % matched.
  lags = zeros(length(u)+length(v)-1,1);
  i0 = 1-length(v);
  i1 = length(u)-1;
  max_len = min(length(u),length(v));
  for i = i0:i1
    if i < 0
      vi = (1-i):min(length(v),max_len-i);
      ui = 1:length(vi);
    else
      ui = (i+1):min(length(u),max_len);
      vi = 1:length(ui);
    end
    assert(length(ui) <= length(u), ...
      sprintf('ui length invalid. i=%d len=%d', i, length(u)));
    assert(length(vi) <= length(v), ...
      sprintf('vi length invalid. i=%d len=%d', i, length(v)));
    assert(length(ui) == length(vi), ...
      sprintf('ui/vi lengths not equal: i=%d ui=%d, vi=%d', ...
      i, length(ui), length(vi)));
    lags(i-i0+1) = sum(u(ui) == v(vi));
  end
  mag = max(lags);
  lag = find(lags == mag,1)+i0-1;
  magpct = 100*mag/sum(~isnan(v));
end

function Snew = align_by_heading(S, T, min_skip_size)
  % S is the reference timebase
  % T is the imperfect timebase
  % Assume that time shifts happen discontinuities of some minimum size
  % Split the time range into more-or-less continguous regions, and try
  % to line T up with S in each region
  u = S.hdng;
  Xu = 1:length(u);
  f = figure;
  ax = axes(f);
  plot(ax, Xu, u);
  hold(ax,'on');
  title(ax, sprintf('%s:%s aligned to %s:%s', ...
    T.stream, T.run, S.stream, S.run));
  drawnow;

  dsiT = diff(T.T10);
  Vskip = find(dsiT<0 | dsiT > min_skip_size);
  fprintf(1,'Align %s:%s to %s:%s: %d possible region(s)\n', T.stream, T.run, S.stream, S.run, length(Vskip)+1);
  Si = 1;
  legends = cell(length(Vskip)+2);
  legends{1} = S.run;
  n_legends = 1;
  starts = [1;Vskip+1];
  ends = [Vskip; length(T.T10)];
  lengths = ends-starts+1;
  Venough = find(lengths > 20)';
  % fprintf(1, 'There are %d region(s) that appear long enough\n', length(Venough));
  for i = Venough
    R = starts(i):ends(i);
    TT = T.T10(R);
    TTi = round((TT-TT(1))/0.1,0)+1;
    v = NaN*zeros(TTi(end),1);
    v(TTi) = T.hdng(R);
    if sum(isnan(v)) > length(v)*.30
      plotfmt = '.-';
    else
      plotfmt = '-';
    end
    [lag,mag] = get_lag(u,v);
    fprintf(1, '  Region %d, %d:%d (length %d) lag=%d mag=%.1f %%\n', i, ...
      starts(i), ends(i), ends(i)-starts(i)+1, lag, mag);
    % w = conv(fliplr(u),v);
    % The position of the maximum here can be considered the lag
    % A lag of one would then correspond to where the two vectors overlap
    % by only one element. By adjusting, here, lag indicates how far we
    % need to shift u (positive or negative) to get the best alignment.
    % u in this case is the scopex data
    % lag = find(w==max(w)) - length(u) + 1;
    if mag > 20
      Xv = 1:length(v);
      plot(ax,Xv+lag,v,plotfmt);
      n_legends = n_legends+1;
      legends{n_legends} = sprintf('%s:%d-%d', T.run, starts(i), ends(i));
    end
  end
  legend(ax,legends(1:n_legends));
end


