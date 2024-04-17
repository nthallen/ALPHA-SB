prefix = icmt
tmcbase = base.tmc
genuibase = ICMtest.genui

Module TMbase mode=ignore
Module ../TM/ICM20948

TGTDIR = /home/alpha-sb/ICMtest
SCRIPT = VERSION Experiment.config
DISTRIB = interact services
IGNORE = Makefile "*.exe"

icmtdisp : $extbase ICMtest.tbl
icmtjsonext : $extbase $genuibase
icmtalgo : ICMtest.tma
doit : ICMtest.doit
%%
GENUI_ENG_DIR=eng
