%%
scopexeng_10 = load('../../MAT/230929.2/scopexeng_10.mat');
heading = scopexeng_10.heading;
angz = scopexeng_10.angular_velocity_z;

%%
while 1
  hdnew = heading;
  dhdng = diff(hdnew)/0.1; % deg/sec, not per sample
  dHdangz = dhdng./angz(2:end);
  idhda = round(dHdangz,0);
  Index = strfind(idhda',[2 1 0]);
  if ~isempty(Index)
    Index = Index(dhdng(Index+2) == 0);
  end
  if ~isempty(Index)
    hdnew(Index+3) = hdnew(Index+2);
    hdnew(Index+2) = hdnew(Index+1);
    hdnew(Index+1) = hdnew(Index+2) - dhdng(Index)/20;
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
while 1
  hdnew = heading;
  dhdng = diff(hdnew)/0.1; % deg/sec, not per sample
  dHdangz = dhdng./angz(2:end);
  idhda = round(dHdangz,0);
  Index = strfind(idhda',[0 1 2]);
  if ~isempty(Index)
    Index = Index(dhdng(Index) == 0);
  end
  if ~isempty(Index)
    hdnew(Index+1) = hdnew(Index+2);
    hdnew(Index+2) = hdnew(Index+3);
    hdnew(Index+3) = hdnew(Index+2) + dhdng(Index)/20;
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
T = time2d(scopexeng_10.Tscopexeng_10);
figure;
ax = [nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),T,dheading/10,'.');
grid(ax(1),'on');
plot(ax(2),T,angz);
grid(ax(2),'on');
linkaxes(ax,'x');
%%
figure;
plot(dheading,angz,'.');
xlabel('dHeading deg/sec');
ylabel('angz deg/sec');
grid(gca,'on');
set(gca,'PlotBoxAspectRatio',[1,1,1],'DataAspectRatio',[1,1,1]);
xlim([-60,60]);
%%
figure;
plot(T,dHdangz,'.');
ylim([-0.5 2.5]);
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

heading(1) = heading(2); % heading(1) is 0, uninitialized
iheading = heading(1) + cumsum(angz)/10;
dih = diff(iheading-heading)/10;
figure;
ax = [nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),T,iheading-heading);
title(ax(1),'Difference between heading and integral of angz');
grid(ax(1),'on');
figure;
plot(ax(2),T(2:end),dih,'.');
grid(ax(2),'on');
linkaxes(ax,'x');
