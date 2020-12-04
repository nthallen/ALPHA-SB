%%
% B3MB Current calibrations
Channel = { 'B1', 'B2', 'B3', 'B4', 'L1', 'L2', 'L3', 'L4' };
%%
Board = '100V1';
cal = [
    0.9729   -0.1186
    0.9750    0.4272
    0.9787   -0.3005
    0.9797    0.4533
    0.9436    0.0544
    0.9277    1.5622
    0.9376    0.2518
    0.9195    0.7548

];
%%
filename = sprintf('B3MB_%s_cal.tmc', Board);
fd = fopen(filename, 'w');
for i = 1:length(Channel)
  fprintf(fd, 'Calibration (B3MB_%s_%sI_t, B3MB_AMPS) {\n', Board, Channel{i});
  fprintf(fd, '      0, %7.3f,\n', cal(i,2));
  fprintf(fd, '  32768, %7.3f\n}\n', 26.2666*cal(i,1));
end
fclose(fd);
