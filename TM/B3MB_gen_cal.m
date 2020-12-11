%%
% B3MB Current calibrations
Channel = { 'B1', 'B2', 'B3', 'B4', 'L1', 'L2', 'L3', 'L4' };
%%
Board = '100V1';
% These are 'fit' values for 28V1 can (using 100V1 just for short-term
% convenience. These were determined using the battery voltage at around
% 33V
cal = [
    0.9951   -0.3725
    0.9993    0.1933
    0.9981   -0.5162
    1.0070    0.2145
    0.9683   -0.2122
    0.9528    1.3536
    0.9640    0.0000
    0.9495    0.4949
];
%%
calb = [ 1./cal(:,1) -cal(:,2)./cal(:,1)];
%%
filename = sprintf('B3MB_%s_cal.tmc', Board);
fd = fopen(filename, 'w');
for i = 1:length(Channel)
  fprintf(fd, 'Calibration (B3MB_%s_%sI_t, B3MB_AMPS) {\n', Board, Channel{i});
  fprintf(fd, '      0, %7.3f,\n', calb(i,2));
  fprintf(fd, '  32768, %7.3f\n}\n', 68.2667*calb(i,1));
end
fclose(fd);
