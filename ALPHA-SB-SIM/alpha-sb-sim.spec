prefix = asbsim
tmcbase = base.tmc
Module Nav mode=types
swsbase = alpha-sb-sim.sws
swsbase = pmc.sws
cmdbase = alpha-sb.cmd
genuibase = alpha-sb.genui
genuibase = nav.genui

Module Version src=alpha-sb-sim.ver
Module TMbase Panel=Main:

Module PropMtr ID=Left  IDX=0 ADDR=63 FAST=10 SLOW=1 mode=types Panel=Motors:
# try  RPMSGN=:*(-1)
Module PropMtr ID=Right IDX=1 ADDR=62 FAST=10 SLOW=1 DAT= Panel=Motors:
Module PropMtr mode=groups RT1= RT2= Panel=Motors:

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

Module alpha-sb-sim
Module PropMtrSim
Module SerIn
Module SpatialDual FAST=10 Panel=Main:
Module Ascender Panel=Main:
Module Nav

TGTDIR = /home/alpha-sb/Sim
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = services runfile.sim
IGNORE = B3MB_gen_cal.asv

asbsimcol : -lsubbuspp
asbsimsrvr : CAN.oui -lsubbuspp
asbsimclt :
# asbsimdisp : $extbase alpha-sb.tbl B3MB_28V.tbl B3MB_100V.tbl SpatialDual.tbl Housekeeping.tbl
asbsimdisp : $extbase alpha-sb.tbl SpatialDual.tbl Housekeeping.tbl
asbsimalgo : alpha-sb-sim.tma pmc.tma pmc_Left.tma pmc_Right.tma $swsbase
asbsimjsonext : $extbase $genuibase
# B3MBrawext : B3MBraw.cdf
tmserioext : tmserio.tmc tmserio.cc tmserio.oui
Simdoit : Sim.doit
SimSockdoit : SimSock.doit
%%
CXXFLAGS+=-g
