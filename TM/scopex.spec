tmcbase = base.tmc
swsbase = scopex.sws
swsbase = pmc.sws
genuibase = scopex.genui

Module TMbase
Module PropMtr ID=Left  IDX=0 ADDR=63 FAST=2 SLOW=1 mode=types
Module PropMtr ID=Right IDX=1 ADDR=62 FAST=2 SLOW=1 DAT=
Module PropMtr mode=groups RT1= RT2=
Module B3MB mode=types ID=100V1 CAN_ID=1
tmcbase = B3MB_100V1_cal.tmc

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
scopexdisp : scopex.tbl B3MB.tbl Housekeeping.tbl
scopexalgo : scopex.tma pmc.tma pmc_Left.tma pmc_Right.tma $swsbase
scopexjsonext : $genuibase
doit : scopex.doit
%%
CXXFLAGS+=-g
