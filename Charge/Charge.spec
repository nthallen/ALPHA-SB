# Charge.spec
tmcbase = base.tmc
genuibase = Charge.genui

Module TMbase Panel=Plots:
Module BKd Panel=Plots:
Module MPSLd Panel=Plots:

Module B3MB mode=types ID=28V1  CAN_ID=11 Panel=B3MB:
Module B3MB            ID=28V2  CAN_ID=12 Panel=B3MB:
Module B3MB            ID=100V1 CAN_ID=1 Panel=B3MB:
Module B3MB            ID=100V2 CAN_ID=2 Panel=B3MB:
Module B3MB            ID=100V3 CAN_ID=3 Panel=B3MB:
Module B3MB            ID=100V4 CAN_ID=4 Panel=B3MB:
# tmcbase = ../TM/B3MB_28V1_cal.tmc
# tmcbase = ../TM/B3MB_100V1_cal.tmc
# tmcbase = ../TM/B3MB_100V2_cal.tmc
# tmcbase = ../TM/B3MB_100V3_cal.tmc
# tmcbase = ../TM/B3MB_100V4_cal.tmc

TGTDIR = /home/scopex/charge
IGNORE = "*.asv" "*.o" "*.exe" "*.stackdump" Makefile
IGNORE = BKd.genui BKd.tmc BKd.tbl
OBJ = BKd.genui BKd.tmc BKd.tbl
IGNORE = TMbase.tbl TMbase.genui freemem.tmc
OBJ = TMbase.tbl TMbase.genui freemem.tmc

IGNORE = MPSLd.genui MPSLd.tmc MPSLd.tbl
OBJ = MPSLd.genui MPSLd.tmc MPSLd.tbl

IGNORE = B3MB.cmd B3MB.tmc B3MB_T30K75KU.tmc B3MB_col.tmc
IGNORE = B3MB_100V[1234].cmd B3MB_100V[1234].genui B3MB_100V[1234].tbl
IGNORE = B3MB_100V[1234].tmc B3MB_100V[1234]_col.tmc B3MB_100V[1234]_conv.tmc
IGNORE = B3MB_28V1.cmd B3MB_28V1.genui B3MB_28V1.tbl
IGNORE = B3MB_28V1.tmc B3MB_28V1_col.tmc B3MB_28V1_conv.tmc
OBJ = B3MB.cmd B3MB.tmc B3MB_T30K75KU.tmc B3MB_col.tmc
OBJ = B3MB_100V[1234].cmd B3MB_100V[1234].genui B3MB_100V[1234].tbl
OBJ = B3MB_100V[1234].tmc B3MB_100V[1234]_col.tmc B3MB_100V[1234]_conv.tmc
OBJ = B3MB_28V1.cmd B3MB_28V1.genui B3MB_28V1.tbl
OBJ = B3MB_28V1.tmc B3MB_28V1_col.tmc B3MB_28V1_conv.tmc

DISTRIB = interact services

Chargecol : -lsubbuspp
Chargesrvr : ../TM/CAN.oui -lsubbuspp
Chargedisp : $extbase Charge.tbl B3MB_A.tbl B3MB_B.tbl
Chargealgo : Charge.tma
doit : Charge.doit
%%
GENUI_ENG_DIR=eng
CXXFLAGS+=-I../TM
