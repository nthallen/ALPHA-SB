CXXFLAGS = -g -Wall
LDFLAGS = -L/usr/local/lib -ldasio -lnl -ltm
.PHONY : all
all : PropMtrsrvr PMkbd PropMtr PropMtrcol PropMtrclt
OBJ = *.stackdump *.o

PROPMTROBJ = PropMtr.o PropMtroui.o pmc.o
OBJ += PropMtr PropMtroui.cc
PropMtr : $(PROPMTROBJ) /usr/local/lib/libdasio.a
	$(CXX) -o PropMtr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTROBJ) $(LDFLAGS)
PropMtr.o : PropMtr.cc
PropMtroui.o : PropMtroui.cc
PropMtroui.cc : PropMtr.oui
	oui -o PropMtroui.cc PropMtr.oui

PROPMTRCMDOBJ = PropMtrsrvr.o PropMtrcmdoui.o
OBJ += PropMtrsrvr PropMtrcmdoui.cc
PropMtrcmd.cc : diag.cmd
	cmdgen -o PropMtrcmd.cc diag.cmd
PropMtrcmdoui.o : PropMtrcmdoui.cc
PropMtrcmdoui.cc : PropMtrcmd.oui
	oui -o PropMtrcmdoui.cc PropMtrcmd.oui
PropMtrsrvr.o : PropMtrcmd.cc
	$(CXX) -c -o PropMtrsrvr.o $(CPPFLAGS) $(CXXFLAGS) -DSERVER PropMtrcmd.cc
PropMtrsrvr : $(PROPMTRCMDOBJ) /usr/local/lib/libdasio.a
	$(CXX) -o PropMtrsrvr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCMDOBJ) $(LDFLAGS)

PMKBDOBJ = PMkbd.o
OBJ += PMkbd
PMkbd : PMkbd.o /usr/local/lib/libdasio.a
	$(CXX) -o PMkbd $(CPPFLAGS) $(CXXFLAGS) PMkbd.o $(LDFLAGS)

PROPMTRCOLOBJ = tmsrvr.o
OBJ += PropMtrcol
PropMtrcol : $(PROPMTRCOLOBJ) /usr/local/lib/libdasio.a
	$(CXX) -o PropMtrcol $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCOLOBJ) $(LDFLAGS)

PROPMTRCLTOBJ = PropMtrclt.o PropMtrcltoui.o
OBJ += PropMtrclt PropMtrcltoui.cc
PropMtrclt.o : PropMtrcmd.cc
	$(CXX) -c -o PropMtrclt.o $(CPPFLAGS) $(CXXFLAGS) -DCLIENT PropMtrcmd.cc
PropMtrcltoui.o : PropMtrcltoui.cc
PropMtrcltoui.cc : PropMtrclt.oui
	oui -o PropMtrcltoui.cc PropMtrclt.oui
PropMtrclt : $(PROPMTRCLTOBJ) /usr/local/lib/libdasio.a
	$(CXX) -o PropMtrclt $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCLTOBJ) $(LDFLAGS) -lncurses

clean :
	rm -f $(OBJ)
