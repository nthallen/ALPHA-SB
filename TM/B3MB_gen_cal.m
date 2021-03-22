%%
% B3MB Current calibrations
Channel = { 'B1', 'B2', 'B3', 'B4', 'L1', 'L2', 'L3', 'L4' };
% These are 'fit' values for 28V1, SN#2 can
Cal.I28V1 = [
  0.9963 -0.3794
  0.9992  0.1932
  0.9991 -0.5168
  1.0078  0.2106
  0.9680 -0.2127
  0.9526  1.3500
  0.9644 -0.0023
  0.9497  0.4907
];

% 100V1, SN#4
Cal.I100V1 = [
  0.9720  1.6474
  0.9791  1.0595
  0.9927  0.3201
  0.9958  0.4011
  0.9423  1.2080
  0.9688 -0.1246
  0.9507  0.3924
  0.9579  0.5767
];

% 100V2, SN#5
Cal.I100V2 = [
  0.9665 1.8817
  0.9886 0.1010
  0.9951 0.0606
  0.9802 0.6773
  0.9599 0.1616
  0.9464 1.1230
  0.9608 0.5747
  0.9521 0.8937
];

% 100V3, SN#1
Cal.I100V3 = [
  0.9865 0.4635
  1.0000 0.0000
  1.0000 0.0000
  1.0000 0.0000
  0.9508 1.0675
  0.9603 0.6119
  1.0000 0.0000
  1.0000 0.0000
];

% 100V4, SN#3
Cal.I100V4 = [
  0.9938  0.3398
  1.0034  0.4073
  1.0028  0.2085
  0.9963 -0.0483
  0.9695  0.7369
  0.9677 -0.4137
  0.9612  0.1002
  0.9632  0.6870
];

Boards = fields(Cal);
for Bi = 1:length(Boards)
  fld = Boards{Bi};
  cal = Cal.(fld);
  Board = fld(2:end);
  calb = [ 1./cal(:,1) -cal(:,2)./cal(:,1)];
  filename = sprintf('B3MB_%s_cal.tmc', Board);
  fd = fopen(filename, 'w');
  for i = 1:length(Channel)
    fprintf(fd, 'Calibration (B3MB_%s_%sI_t, B3MB_AMPS) {\n', Board, Channel{i});
    fprintf(fd, '      0, %7.3f,\n', calb(i,2));
    fprintf(fd, '  32768, %7.3f\n}\n', 68.2667*calb(i,1));
  end
  fclose(fd);
  fprintf(1,'Generated %s\n', filename);
end
