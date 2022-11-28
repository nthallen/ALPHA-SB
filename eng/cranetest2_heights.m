function [Time,Height] = cranetest2_heights
% [Time,Height] = crantest2_heights;
% Time is seconds since midnight UTC on Nov. 14 2022 (Day 1), carrying
% straight through day Day 2. This time is as recorded on the SerIn server
% machine. There is a discontinuity in the SerIn data for reasons unknown.
% NOTE that time recorded in SCoPEx runs 221109.5 and 221110.1 are way off
% from the correct time and will need to be adjusted.
%
% Height is in meters above the ground as recorded by the laser range
% finder.
%%
raw_height = [
18 00 0       36.3
18 02 27.813  28.86
18 03 56.971  21
18 05 12.412  12.96
18 07 03.972  4.68
18 08 46.340  3.48
19 56 06.696  3.2
19 57 10.391  3.6
21 00 25.832  20.2
21 02 38.179  27.2
21 04 48.195  35.27
15 17 57.635  35.5
15 21 10.865  20.03
15 25 35.273  1.65
15 25 51.805  1.5
20 58 51.881  21.1];

Time = time2d(raw_height(:,1), raw_height(:,2), raw_height(:,3));
day2 = find(diff(Time)<0,1)+1;
Time(day2:end) = Time(day2:end)+24*3600;
Height = raw_height(:,4);

