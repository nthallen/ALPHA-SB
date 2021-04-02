prefix = scopex
tmcbase = base.tmc
swsbase = scopex.sws
swsbase = pmc.sws
cmdbase = scopex.cmd
genuibase = scopex.genui

Module Version src=scopexsim.ver
Module TMbase

Module PropMtr ID=Left  IDX=0 ADDR=63 FAST=10 SLOW=1 mode=types
Module PropMtr ID=Right IDX=1 ADDR=62 FAST=10 SLOW=1 DAT=
Module PropMtr mode=groups RT1= RT2=

# Module B3MB mode=types ID=28V1  CAN_ID=2
# Module B3MB            ID=100V1 CAN_ID=6
# Module B3MB            ID=100V2 CAN_ID=7
# Module B3MB            ID=100V3 CAN_ID=8
# Module B3MB            ID=100V4 CAN_ID=3
# tmcbase = B3MB_28V1_cal.tmc
# tmcbase = B3MB_100V1_cal.tmc
# tmcbase = B3MB_100V2_cal.tmc
# tmcbase = B3MB_100V3_cal.tmc
# tmcbase = B3MB_100V4_cal.tmc

Module scopexsim
Module PropMtrSim
Module SerIn
Module SpatialDual FAST=10
Module Ascender

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services runfile.sim
IGNORE = B3MB_gen_cal.asv

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
# scopexdisp : $extbase scopex.tbl B3MB_28V.tbl B3MB_100V.tbl SpatialDual.tbl Housekeeping.tbl
scopexdisp : $extbase scopex.tbl SpatialDual.tbl Housekeeping.tbl
scopexalgo : scopex.tma pmc.tma pmc_Left.tma pmc_Right.tma $swsbase
scopexjsonext : $extbase $genuibase
# B3MBrawext : B3MBraw.cdf
tmserioext : tmserio.tmc tmserio.cc tmserio.oui
doit : scopex.doit
Simdoit : Sim.doit
%%
CXXFLAGS+=-g
