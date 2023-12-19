# Charge.spec
# See README.txt for physical configuration
tmcbase = base.tmc
cmdbase = Charge.cmd
genuibase = Charge.genui
swsbase = Charge.sws

Module TMbase Panel=Plots:
Module BKd Panel=Plots:
Module MPSLd Panel=Plots:

Module B3MB mode=types
Module B3MB mode=V28  ID=28V1  CAN_ID=11 Panel=B3MB: T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V28  ID=28V2  CAN_ID=12 Panel=B3MB:
Module B3MB mode=V28  ID=28V3  CAN_ID=13 Panel=B3MB: T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V1 CAN_ID=1 Panel=B3MB:  T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V2 CAN_ID=2 Panel=B3MB:  T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V3 CAN_ID=3 Panel=B3MB:  T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V4 CAN_ID=4 Panel=B3MB:  T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V5 CAN_ID=5 Panel=B3MB: T1=# DT1= LT1="" T1L=/* T1R=*/ \
                                                    T3=# DT3= LT3="" T3L=/* T3R=*/ \
                                                    T4=# DT4= LT4="" T4L=/* T4R=*/ \
                                                    T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V6 CAN_ID=6 Panel=B3MB: T2=# DT2= LT2="" T2L=/* T2R=*/ \
                                                    T3=# DT3= LT3="" T3L=/* T3R=*/ \
                                                    T4=# DT4= LT4="" T4L=/* T4R=*/ \
                                                    T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V7 CAN_ID=7 Panel=B3MB: T2=# DT2= LT2="" T2L=/* T2R=*/ \
                                                    T3=# DT3= LT3="" T3L=/* T3R=*/ \
                                                    T4=# DT4= LT4="" T4L=/* T4R=*/ \
                                                    T5=# DT5= LT5="" T5L=/* T5R=*/
Module B3MB mode=V100 ID=100V8 CAN_ID=8 Panel=B3MB: T2=# DT2= LT2="" T2L=/* T2R=*/ \
                                                    T3=# DT3= LT3="" T3L=/* T3R=*/ \
                                                    T4=# DT4= LT4="" T4L=/* T4R=*/ \
                                                    T5=# DT5= LT5="" T5L=/* T5R=*/
tmcbase = B3MB_cal.tmc

TGTDIR = /home/scopex/charge
IGNORE = "*.asv" "*.o" "*.exe" "*.stackdump" Makefile
IGNORE = BKd.genui BKd.tmc BKd.tbl
OBJ = BKd.genui BKd.tmc BKd.tbl
IGNORE = TMbase.tbl TMbase.genui freemem.tmc
OBJ = TMbase.tbl TMbase.genui freemem.tmc
IGNORE = SWData.cmd SWData.h SWData.tmc SWData_col.tmc
OBJ = SWData.cmd SWData.h SWData.tmc SWData_col.tmc

IGNORE = MPSLd.genui MPSLd.tmc MPSLd.tbl
OBJ = MPSLd.genui MPSLd.tmc MPSLd.tbl


DISTRIB = interact services

Chargecol : -lsubbuspp
Chargesrvr : ../TM/CAN.oui -lsubbuspp
Chargedisp : $extbase Charge.tbl B3MB_A.tbl B3MB_B.tbl B3MB_C.tbl
Chargealgo : Charge.tma $swsbase
Chargejsonext : $extbase $genuibase
doit : Charge.doit
%%
GENUI_ENG_DIR=eng
CXXFLAGS+=-I../TM
