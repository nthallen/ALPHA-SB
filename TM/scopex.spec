tmcbase = base.tmc
swsbase = scopex.sws
swsbase = pmc.sws
genuibase = scopex.genui

Module TMbase
Module PropMtr mode=types ID=Left IDX=0 ADDR=63 FAST=2 SLOW=1
# Module PropMtr ID=Right ADDR=64 IDX=1 FAST=2 SLOW=1
Module PropMtr mode=groups

TGTDIR = /home/scopex
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
DISTRIB = interact services

scopexcol : -lsubbuspp
scopexsrvr :
# scopexsrvr : CAN.oui -lsubbuspp
scopexclt :
scopexdisp : scopex.tbl
scopexalgo : scopex.tma pmc_left.tma $swsbase
scopexjsonext : $genuibase
doit : scopex.doit
%%
CXXFLAGS+=-g
