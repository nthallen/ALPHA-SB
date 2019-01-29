#! /bin/bash

N=0
while [ $N -lt 115200 ]; do
  echo -ne \\xFF\\x00
  let N=N+2
done >testfile.dat

