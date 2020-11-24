tmcbase = base.tmc
swsbase = scopex.sws
swsbase = pmc.sws
genuibase = scopex.genui

Module TMbase
Module PropMtr mode=types ID=Left IDX=0 ADDR=63 FAST=2 SLOW=1
# Module PropMtr ID=Right ADDR=64 IDX=1 FAST=2 SLOW=1
Module PropMtr mode=groups
Module B3MB mode=types ID=100V1 CAN_ID=1

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services

scopexcol : -lsubbuspp
scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
scopexdisp : scopex.tbl B3MB.tbl
scopexalgo : scopex.tma pmc_Left.tma $swsbase
scopexjsonext : $genuibase
doit : scopex.doit
%%
CXXFLAGS+=-g
