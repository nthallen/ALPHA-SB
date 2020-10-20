tmcbase = base.tmc

genuibase = scopex.genui

Module TMbase
Module PropMtr mode=types ID=Left IDX=0 ADDR=63 FAST=2 SLOW=1
# Module PropMtr ID=Right ADDR=64 IDX=1 FAST=2 SLOW=1

TGTDIR = $(FLIGHT_NODE)/home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
# SCRIPT = doscopexclt.sh cyg_nc.sh
IDISTRIB = interact.sh

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
#scopexsrvr :
scopexclt :
scopexdisp : scopex.tbl
%%
CXXFLAGS+=-g
