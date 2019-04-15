tmcbase = base.tmc
tmcbase = /usr/local/share/linkeng/flttime.tmc
colbase =
# genuibase = scopex.genui

Module PropMtr mode=types ID=Left IDX=0
# Module PropMtr ID=Right IDX=1

TGTDIR = $(PWD)/../..
IGNORE = "*.o" "*.exe" "*.stackdump" Makefile
SCRIPT = doscopexclt.sh cyg_nc.sh
IDISTRIB = interact.sh cleanup.sh

scopexcol :
scopexsrvr :
scopexclt :
scopexdisp : scopex.tbl
%%
CXXFLAGS=-g
