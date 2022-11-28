function [P1alog_dT, P1blog_dT, P2log_dT] = cranetest2_timeoffsets
% [P1alog_dT, P1blog_dT, P2log_dT] = cranetest2_timeoffsets;
% The data from Crane Test 2 was stored on the flight computer in 3 runs:
%
%   P1alog_dT corresponds to Day 1 AM: '221109.5'
%   P1blog_dT corresponds to Day 1 PM: '221110.1'
%   P2log_dT  corresponds to Day 2:    '221115.1'
%
% The time recorded in each of these runs needs to have the corresponding
% offset subtracted to obtain the real time.
%
% The teletry received via radio was stored on the SerIn server in one run
% encompassing both days:
%      '221116.1'
%
% The flight computer does not have a realtime clock, so the time
% information is offset by some fixed quantity which is different on
% different days. The data reported in the command log on the flight
% computer matches the time recorded in the telemetry log.
%
% The SerIn server exhibited a bug in the serin program that caused the
% time reported by telemetry to be different from the time reported in the
% command log. The command log reports the correct time.
%
% These offsets provide the difference in seconds between the time reported
% on the flight computer in telemetry and the real time recorded in the
% SerIn server's command log.
%
% A different set of offsets is required to correctly offset the time
% recorded in the SerIn server's telemetry log.
%%
% P1a log: 01:21:51.105 srvr: tmserio: b3MB 100V4 load 1 Off
% SI  log: 17:16:27.664 srvr: cmd_wri: b3MB 100V4 load 1 Off
P1alog_dT = time2d(1,21,51.105)-time2d(17,16,27.664);
% P1b log: 03:50:48.697 srvr: tmserio: ascender set Speed -100 pct For 10 sec
% SI  log: 19:45:25.206 srvr: cmd_wri: ascender set Speed -100 pct For 10 sec
P1blog_dT = time2d(3,50,48.697)-time2d(19,45,25.206);
% P2 log: 15:35:43.950 srvr: tmserio: set Nav pGain 8
% SI log: 15:36:01.681 srvr: cmd_wri: set Nav pGain 8
P2log_dT = time2d(15,35,43.950)-time2d(24+15,36,01.681);

% P1alog_dT is the difference between the log on the flight
% computer for the first half of day 1, run '221109.5', and the log on the SerIn server.

% P1blog_dT is the difference between the log on the flight
% computer and the log on the SerIn server.

% P2log_dT is the difference between the log on the flight
% computer and the log on the SerIn server.

% The log on the serin server used the correct time, so in this way 
