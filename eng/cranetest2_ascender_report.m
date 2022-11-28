%%
primary_datadir = ne_load_runsdir('SCoPEx_Data_Dir');
serin_datadir = ne_load_runsdir('SCoPEx_SI_Data_Dir');

pri_day1_a = '221109.5';
pri_day1_b = '221110.1';
pri_day2 =   '221115.1';
SI_day1_2 =  '221116.1';

SI = load_eng_mat(serin_datadir, SI_day1_2, 'scopexeng_1');
P1a = load_eng_mat(primary_datadir, pri_day1_a, 'scopexeng_1');
F1a = load_eng_mat(primary_datadir, pri_day1_a, 'scopexeng_10');
P1b = load_eng_mat(primary_datadir, pri_day1_b, 'scopexeng_1');
F1b = load_eng_mat(primary_datadir, pri_day1_b, 'scopexeng_10');
P2  = load_eng_mat(primary_datadir, pri_day2, 'scopexeng_1');
F2  = load_eng_mat(primary_datadir, pri_day2, 'scopexeng_10');
%%
figure;
ax = [
  subplot(2,5,1)
  subplot(2,5,2)
  subplot(2,5,3)
  subplot(2,5,4)
  subplot(2,5,5) ];
bx = [
  subplot(2,5,6)
  subplot(2,5,7)
  subplot(2,5,8)
  subplot(2,5,9)
  subplot(2,5,10) ];
[Tlog,Hlog] = cranetest2_heights;
AscErr = zeros(size(Tlog));
heightErr = zeros(size(Tlog));
%%
% P1a log: 01:21:51.105 srvr: tmserio: b3MB 100V4 load 1 Off
% SI  log: 17:16:27.664 srvr: cmd_wri: b3MB 100V4 load 1 Off
P1alog_dT = time2d(1,21,51.105)-time2d(17,16,27.664);
I1a = 1:6;
% P1alog_dT is the difference between the log on the flight
% computer and the log on the SerIn server. This is needed to map the
% ascender height data from the SerIn log onto the flight data.
% Take our initial ascender height as truth and calculate offsets
% for height and AscPosition
T1a = Tlog(I1a)+P1alog_dT;
dheight = Hlog(1) - interp1(F1a.T, F1a.height, T1a(1),'nearest');
dAscPos = Hlog(1) - interp1(P1a.T, P1a.AscPosition, T1a(1),'nearest');
AscPos1a = P1a.AscPosition+dAscPos;
height1a = F1a.height+dheight;
AscErr(I1a) = interp1(P1a.T,AscPos1a,T1a,'nearest') - Hlog(I1a);
heightErr(I1a) = interp1(F1a.T,height1a,T1a,'nearest') - Hlog(I1a);
plot(ax(1),P1a.T,AscPos1a, F1a.T,height1a, T1a,Hlog(I1a),'*');
xlim(ax(1),T1a([1 end])' -15*[1,-1]);
plot(bx(1),T1a,AscErr(I1a),'*',T1a,heightErr(I1a),'+');
drawnow;
xlim(bx(1),T1a([1 end])' -15*[1,-1]);
%%
% P1b log: 03:50:48.697 srvr: tmserio: ascender set Speed -100 pct For 10 sec
% SI  log: 19:45:25.206 srvr: cmd_wri: ascender set Speed -100 pct For 10 sec
P1blog_dT = time2d(3,50,48.697)-time2d(19,45,25.206);
% P1blog_dT is the difference between the log on the flight
% computer and the log on the SerIn server. This is needed to map the
% ascender height data from the SerIn log onto the flight data.
[Tlog,Hlog] = cranetest2_heights;
I1b = 7:11;
% Take our initial ascender height as truth and calculate offsets
% for height and AscPosition
T1b = Tlog(I1b)+P1alog_dT;
dheight = Hlog(I1b(1)) - interp1(F1b.T, F1b.height, T1b(1),'nearest');
dAscPos = Hlog(I1b(1)) - interp1(P1b.T, P1b.AscPosition, T1b(1),'nearest');
AscPos1b = P1b.AscPosition+dAscPos;
height1b = F1b.height+dheight;
AscErr(I1b) = interp1(P1b.T,AscPos1b,T1b,'nearest') - Hlog(I1b);
heightErr(I1b) = interp1(F1b.T,height1b,T1b,'nearest') - Hlog(I1b);
plot(ax(2),P1b.T,AscPos1b, F1b.T,height1b, T1b,Hlog(I1b),'*');
xlim(ax(2),T1b([1 2])' - 15*[1,-1]);
plot(bx(2),T1b,AscErr(I1b),'*',T1b,heightErr(I1b),'+');
xlim(bx(2),T1b([1 2])' -15*[1,-1]);

plot(ax(3),P1b.T,AscPos1b, F1b.T,height1b, T1b,Hlog(I1b),'*');
xlim(ax(3),T1b([3 end])' - 15*[1,-1]);
plot(bx(3),T1b,AscErr(I1b),'*',T1b,heightErr(I1b),'+');
xlim(bx(3),T1b([3 end])' -15*[1,-1]);
%%
% P2 log: 15:35:43.950 srvr: tmserio: set Nav pGain 8
% SI log: 15:36:01.681 srvr: cmd_wri: set Nav pGain 8
P2log_dT = time2d(15,35,43.950)-time2d(24+15,36,01.681);
% P2log_dT is the difference between the log on the flight
% computer and the log on the SerIn server. This is needed to map the
% ascender height data from the SerIn log onto the flight data.
%
[Tlog,Hlog] = cranetest2_heights;
I2 = 12:length(Tlog);
% Take our initial ascender height as truth and calculate offsets
% for height and AscPosition
T2 = Tlog(I2)+P2log_dT;
dheight = Hlog(I2(1)) - interp1(F2.T, F2.height, T2(1),'nearest');
dAscPos = Hlog(I2(1)) - interp1(P2.T, P2.AscPosition, T2(1),'nearest');
AscPos2 = P2.AscPosition+dAscPos;
height2 = F2.height+dheight;
AscErr(I2) = interp1(P2.T,AscPos2,T2,'nearest') - Hlog(I2);
heightErr(I2) = interp1(F2.T,height2,T2,'nearest') - Hlog(I2);
plot(ax(4),P2.T,AscPos2, F2.T,height2, T2,Hlog(I2),'*');
xlim(ax(4),T2([1 4])' - 15*[1,-1]);
plot(bx(4),T2,AscErr(I2),'*',T2,heightErr(I2),'+');
xlim(bx(4),T2([1 4])' -15*[1,-1]);

plot(ax(5),P2.T,AscPos2, F2.T,height2, T2,Hlog(I2),'*');
xlim(ax(5),T2(5)' - 30*[1,-1]);
plot(bx(5),T2,AscErr(I2),'*',T2,heightErr(I2),'+');
xlim(bx(5),T2(5)' -30*[1,-1]);
%%
ylim(ax,[0 40]);
ylim(bx,[-1.5 1.5]);
set(bx,'YGrid','On');
title(ax(3),'Crane Test 2 Ascender Heights');
ylabel(ax(1),'meters');
xlabel(ax(1),'Day 1 Descent');
xlabel(ax(2),'Day 1');
xlabel(ax(3),'Day 1 Ascent');
xlabel(ax(4),'Day 2 Descent');
xlabel(ax(5),'Day 2 Ascent');
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
