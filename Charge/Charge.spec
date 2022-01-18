# Charge.spec
tmcbase = base.tmc
genuibase = Charge.genui

Module TMbase Panel=Plots:
Module BKd Panel=Plots:
Module MPSLd Panel=Plots:

TGTDIR = /home/scopex/charge
IGNORE = "*.asv" "*.o" "*.exe" "*.stackdump" Makefile
IGNORE = BKd.genui BKd.tmc BKd.tbl
IGNORE = MPSLd.genui MPSLd.tmc MPSLd.tbl
OBJ = BKd.genui BKd.tmc BKd.tbl
IGNORE = TMbase.tbl TMbase.genui freemem.tmc
OBJ = TMbase.tbl TMbase.genui freemem.tmc
DISTRIB = interact services

Chargedisp : $extbase Charge.tbl
Chargealgo : Charge.tma
doit : Charge.doit
%%
GENUI_ENG_DIR=eng
