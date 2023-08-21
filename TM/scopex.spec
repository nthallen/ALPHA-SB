tmcbase = base.tmc
Module Nav mode=types
swsbase = scopex.sws
swsbase = pmc.sws
cmdbase = scopex.cmd
cmdbase = B3MB_map.cmd
genuibase = scopex.genui

Module Version src=scopex.ver
Module TMbase Panel=Main:

Module PropMtr ID=Left  IDX=0 ADDR=63 FAST=2 SLOW=1 mode=types Panel=Motors:
# Will try  RPMSGN=:*(-1) to make RPM positive. Works for ui_, not for rt_ yet
Module PropMtr ID=Right IDX=1 ADDR=62 FAST=2 SLOW=1 DAT= Panel=Motors:
Module PropMtr mode=groups RT1= RT2= Panel=Motors:

# B3MB Configuration as per Under Link 20220813 Rev 2
Module B3MB mode=types
Module B3MB mode=V28  ID=28V1  CAN_ID=11 Panel=B3MB: L1=EngPort28 L3=EngStbd28 L4=DataSys28
Module B3MB mode=V28  ID=28V2  CAN_ID=12 Panel=B3MB:
Module B3MB mode=V100 ID=100V1 CAN_ID=1 Panel=B3MB: L3=EngPort100 L4=AscSec1
Module B3MB mode=V100 ID=100V2 CAN_ID=2 Panel=B3MB: L1=AscRes1 L2=AscPri1
Module B3MB mode=V100 ID=100V3 CAN_ID=3 Panel=B3MB: L1=AscRes2 L2=AscPri2
Module B3MB mode=V100 ID=100V4 CAN_ID=4 Panel=B3MB: L3=EngStbd100 L4=AscSec2
#tmcbase = B3MB_28V1_cal.tmc
#tmcbase = B3MB_100V1_cal.tmc
#tmcbase = B3MB_100V2_cal.tmc
#tmcbase = B3MB_100V3_cal.tmc
#tmcbase = B3MB_100V4_cal.tmc

# Module scopexsim
Module PropMtrSim
#Module SerIn
Module Sat
Module SpatialDual FAST=10 Panel=Main:
Module Ascender Panel=Main:
Module RFDio
Module Nav

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services runfile.sim
IGNORE = B3MB_gen_cal.asv

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopextxsrvr :
scopexclt :
scopexdisp : $extbase Summary.tbl scopex.tbl B3MB_28V.tbl B3MB_100V.tbl SpatialDual.tbl Housekeeping.tbl
scopexalgo : scopex.tma pmc.tma pmc_Left.tma pmc_Right.tma $swsbase
scopexjsonext : $extbase $genuibase
# B3MBrawext : B3MBraw.cdf
tmserioext : tmserio.tmc tmserio.cc tmserio.oui
doit : scopex.doit
Simdoit : Sim.doit
SimSockdoit : SimSock.doit
%%
CXXFLAGS+=-g
