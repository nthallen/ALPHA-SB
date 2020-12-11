function h = stacked_load_current(minvals, T, varargin)
% T time vector
% varargin consists of 3 args for each current
% The first is the current measurement
% The second is the voltage measurement
% The third is the linetype string (may not use that)
n_lines = length(varargin)/3;
I = zeros(length(T), n_lines);
for i=1:n_lines
  Ii = varargin{i*3-2};
  Vi = varargin{i*3-1};
  Ii(Ii < minvals(i)) = 0;
  Ii(Vi < 5) = 0;
  I(:,i) = Ii;
end
h = area(T,I);
