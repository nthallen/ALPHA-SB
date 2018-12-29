CPPFLAGS = -DSERVER
CXXFLAGS = -g
LDFLAGS = -L/usr/local/lib -ldasio -lnl -ltm
.PHONY : all
all : PropMtrcmd PMkbd PropMtr
OBJ = *.stackdump *.o

PROPMTROBJ = PropMtr.o PropMtroui.o
OBJ += PropMtr PropMtroui.cc
PropMtr : $(PROPMTROBJ)
	$(CXX) -o PropMtr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTROBJ) $(LDFLAGS)
PropMtr.o : PropMtr.cc
PropMtroui.o : PropMtroui.cc
PropMtroui.cc : PropMtr.oui
	oui -o PropMtroui.cc PropMtr.oui

PROPMTRCMDOBJ = PropMtrcmd.o PropMtrcmdoui.o
OBJ += PropMtrcmd PropMtrcmdoui.cc
PropMtrcmd.cc : diag.cmd
	cmdgen -o PropMtrcmd.cc diag.cmd
PropMtrcmdoui.o : PropMtrcmdoui.cc
PropMtrcmdoui.cc : PropMtrcmd.oui
	oui -o PropMtrcmdoui.cc PropMtrcmd.oui
PropMtrcmd.o : PropMtrcmd.cc
PropMtrcmd : $(PROPMTRCMDOBJ) /usr/local/lib/libdasio.a
	$(CXX) -o PropMtrcmd $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCMDOBJ) $(LDFLAGS)

PMKBDOBJ = PMkbd.o
OBJ += PMkbd
PMkbd : PMkbd.o /usr/local/lib/libdasio.a
	$(CXX) -o PMkbd $(CPPFLAGS) $(CXXFLAGS) PMkbd.o $(LDFLAGS)

clean :
	rm -f $(OBJ)
