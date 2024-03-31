function dev = load_vibrations(ifile, NS, Nsamples)
dev(NS) = struct('data', zeros(Nsamples,3), 'nrows', 0);
for i=1:NS-1
  dev(i) = dev(NS);
end
% ifile = '00.dat';
fid = fopen(ifile,'r');
data = fread(fid,'int16');
data = reshape(data,3,[])';
fclose(fid);
nrow = 1;
while nrow < size(data,1)
  devno = data(nrow,1)+1;
  fs = data(nrow,2);
  nrows = data(nrow,3);
  rdata = data(nrow+(1:nrows),:) * 2^(fs-14);
  dev(devno).data(dev(devno).nrows + (1:nrows),:) = rdata;
  dev(devno.nrows) = dev(devno.nrows) + nrows;
end
