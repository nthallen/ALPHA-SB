tmcbase = base.tmc
swsbase = scopex.sws
swsbase = pmc.sws
genuibase = scopex.genui

Module TMbase
Module PropMtr ID=Left  IDX=0 ADDR=63 FAST=2 SLOW=1 mode=types
Module PropMtr ID=Right IDX=1 ADDR=62 FAST=2 SLOW=1 DAT=
Module PropMtr mode=groups RT1= RT2=
Module B3MB mode=types ID=28V1  CAN_ID=2
Module B3MB            ID=28V2  CAN_ID=3
Module B3MB            ID=100V1 CAN_ID=6
Module B3MB            ID=100V2 CAN_ID=7
Module B3MB            ID=100V3 CAN_ID=8
Module SerIn
Module scopexsim
tmcbase = B3MB_100V1_cal.tmc
Module SpatialDual FAST=10

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services runfile.sim

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
scopexdisp : $extbase scopex.tbl B3MB_28V.tbl B3MB_100V.tbl SpatialDual.tbl Housekeeping.tbl
scopexalgo : scopex.tma pmc.tma pmc_Left.tma pmc_Right.tma $swsbase
scopexjsonext : $extbase $genuibase
B3MBrawext : B3MBraw.cdf
tmserioext : tmserio.tmc tmserio.cc tmserio.oui
doit : scopex.doit
Simdoit : Sim.doit
%%
CXXFLAGS+=-g
