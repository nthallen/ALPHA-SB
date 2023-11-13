%%
scopexeng_10 = load('../../MAT/230929.2/scopexeng_10.mat');
heading = scopexeng_10.heading;
angz = scopexeng_10.angular_velocity_z;
T = time2d(scopexeng_10.Tscopexeng_10);
%%
for patlen = 2:6
  %%
  pattern = [2 ones(1,patlen-2) 0];
  while 1
    hdnew = heading;
    dhdng = diff(hdnew)/0.1; % deg/sec, not per sample
    dHdangz = dhdng./angz(2:end);
    idhda = round(dHdangz,0);
    idhdaz = idhda == 0;
    idhda(idhdaz) = dHdangz(idhdaz);
    Index = strfind(idhda',pattern);
    if ~isempty(Index)
      for shftidx = patlen:-1:1
        hdnew(Index+shftidx+1) = hdnew(Index+shftidx);
      end
      hdnew(Index+1) = hdnew(Index+2) - dhdng(Index)/20;
      % hdnew(Index+3) = hdnew(Index+2);
      % hdnew(Index+2) = hdnew(Index+1);
      % hdnew(Index+1) = hdnew(Index+2) - dhdng(Index)/20;
    end
    dhdngnew = diff(hdnew)/0.1; % deg/sec, not per sample
    dHdangznew = dhdngnew./angz(2:end);
    idhdanew = round(dHdangznew,0);
    invest = [heading(2:end) dhdng dhdng ~= 0 idhda hdnew(2:end) dhdngnew idhdanew dHdangznew];
    heading = hdnew;
    dhdng = dhdngnew;
    if isempty(Index)
      break;
    end
  end
  %%
  pattern = [0 ones(1,patlen-2) 1];
  while 1
    hdnew = heading;
    dhdng = diff(hdnew)/0.1; % deg/sec, not per sample
    dHdangz = dhdng./angz(2:end);
    idhda = round(dHdangz,0);
    idhdaz = idhda == 0;
    idhda(idhdaz) = dHdangz(idhdaz);
    Index = strfind(idhda',pattern);
    if ~isempty(Index)
      for shftidx = 1:patlen
        hdnew(Index+shftidx) = hdnew(Index+shftidx+1);
      end
      hdnew(Index+patlen) = hdnew(Index+patlen-1) + dhdng(Index)/20;
      % hdnew(Index+1) = hdnew(Index+2);
      % hdnew(Index+2) = hdnew(Index+3);
      % hdnew(Index+3) = hdnew(Index+2) + dhdng(Index)/20;
    end
    dhdngnew = diff(hdnew)/0.1; % deg/sec, not per sample
    dHdangznew = dhdngnew./angz(2:end);
    idhdanew = round(dHdangznew,0);
    invest = [heading(2:end) dhdng dhdng ~= 0 idhda hdnew(2:end) dhdngnew idhdanew dHdangznew];
    heading = hdnew;
    dhdng = dhdngnew;
    if isempty(Index)
      break;
    end
  end
  %%
  dheading = [0;dhdng];
  dHdangz = dheading./angz;
  figure;
  plot(dheading,angz,'.');
  title(sprintf('patlen = %d', patlen));
  xlabel('dHeading deg/sec');
  ylabel('angz deg/sec');
  grid(gca,'on');
  set(gca,'PlotBoxAspectRatio',[1,1,1],'DataAspectRatio',[1,1,1]);
  xlim([-60,60]);
end
%%
dhdng = diff(heading)/0.1; % deg/sec, not per sample
dHdangz = dhdng./angz(2:end);
figure;
plot(T(2:end),dHdangz,'.');
ylim([-0.5 2.5]);
%%
heading(1) = heading(2); % heading(1) is 0, uninitialized
dheading = [0;diff(heading)/0.1]; % deg/sec
dHdangz = dheading./angz;
%%
figure;
ax = [nsubplot(3,1,1) nsubplot(3,1,2) nsubplot(3,1,3)];
plot(ax(1),T,dheading,'.');
grid(ax(1),'on');
plot(ax(2),T,angz,'.');
grid(ax(2),'on');
plot(ax(3),T,dHdangz,'.');
ylim(ax(3),[-.5 2.5]);
grid(ax(3),'on');
linkaxes(ax,'x');
%%
% OK, whatever. Cleaning up heading is tricky, but all we
% are really concerned with here is where dheading is way off from the
% angular velocity
Vwayout = dHdangz > 2.5 | dHdangz < -.5;
figure;
plot(T(Vwayout),dheading(Vwayout)/10,'.');
ylabel('degrees');
grid on
%%
heading(1) = heading(2); % heading(1) is 0, uninitialized
iheading = heading(1) + cumsum(angz)/10;
dih = diff(iheading-heading); % degrees

figure;
ax = [nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),T,iheading-heading);
title(ax(1),'Difference between heading and integral of angz');
grid(ax(1),'on');
plot(ax(2),T(2:end),dih,'.');
grid(ax(2),'on');
linkaxes(ax,'x');
%%
figure;
plot(T,dheading,'o',T,angz);
grid;
%%
% Try to reconstruct a better heading by
%  -using heading when dual_heading_active
%  -integrating angular_velocity_z when it isn't
% Q: Are the discontinuities any better?
%
% 1: measure discontinuities due to acquiring heading
dual_heading_active = bitand(scopexeng_10.filter_status,2^10) ~= 0;
hdng_acqd = find(diff(dual_heading_active)>0);
hdng_lost = [1;find(diff(dual_heading_active)<0)];
heading(1) = heading(2); % heading(1) is 0, uninitialized
dheading = diff(heading);
figure;
plot(T(hdng_acqd+1),dheading(hdng_acqd),'.');
ylabel('\Delta heading on heading acquisition');
%%
% 2: Create alternative heading (probably won't be much better)
int_ang_all = cumsum(angz)/10;
prev_idx = interp1(hdng_lost,hdng_lost,1:length(angz),'previous','extrap')';
int_ang = (int_ang_all - int_ang_all(prev_idx)) .* ~dual_heading_active;
new_heading = dual_heading_active .* heading + ...
  ~dual_heading_active .* (heading(prev_idx)+int_ang);
figure;
ax = nsubplots(4);
stairs(ax(1),T,dual_heading_active,'k');
ylim(ax(1),[-.2 1.2]);
plot(ax(2),T,int_ang,'.');
plot(ax(3),T,heading,T,new_heading);
plot(ax(4),T,new_heading-heading);
linkaxes(ax,'x');
%%
figure;
ax = nsubplots(2);
dhdng_new = diff(new_heading);
plot(ax(1),T(hdng_acqd+1),dheading(hdng_acqd),'o',T(hdng_acqd+1),dhdng_new(hdng_acqd),'+');
plot(ax(2),T(hdng_acqd+1),sign(dheading(hdng_acqd)).*(dhdng_new(hdng_acqd)-dheading(hdng_acqd)),'o');
grid(ax(2),'on');
linkaxes(ax,'x');
