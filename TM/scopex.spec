tmcbase = base.tmc
tmcbase = bmm.tmc
tmcbase = BMM_T30K75KU.tmc
tmcbase = /usr/local/share/linkeng/flttime.tmc

colbase = bmm_col.tmc
# genuibase = scopex.genui

cmdbase = bmm.cmd

Module PropMtr mode=types ID=Left IDX=0
# Module PropMtr ID=Right IDX=1

TGTDIR = $(FLIGHT_NODE)/home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
# SCRIPT = doscopexclt.sh cyg_nc.sh
IDISTRIB = interact.sh

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
scopexdisp : scopex.tbl
%%
CXXFLAGS+=-g
