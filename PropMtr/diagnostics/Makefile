ifdef CROSS_COMPILING
CPPFLAGS += -I/opt/linkeng/am335x/include
LIBDIR = /opt/linkeng/am335x/lib
else
LIBDIR = /usr/local/lib
endif

CXXFLAGS += -g -Wall -std=c++11
LDFLAGS = -L$(LIBDIR) -ldasio -lnl -ltm

.PHONY : all
all : PropMtrsrvr PMkbd PropMtr PropMtrcol PropMtrclt bmmdrv
OBJ = *.stackdump *.o
TGT = root@10.245.83.12:/home/flight

PROPMTROBJ = PropMtr.o PropMtroui.o pmc.o
OBJ += PropMtr PropMtroui.cc
DIST += PropMtr
PropMtr : $(PROPMTROBJ) $(LIBDIR)/libdasio.a
	$(CXX) -o PropMtr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTROBJ) $(LDFLAGS)
PropMtr.o : PropMtr.cc
PropMtroui.o : PropMtroui.cc
PropMtroui.cc : PropMtr.oui
	oui -o PropMtroui.cc PropMtr.oui

PROPMTRCMDOBJ = PropMtrsrvr.o PropMtrsrvroui.o
OBJ += PropMtrsrvr PropMtrsrvroui.cc PropMtrcmd.cc
DIST += PropMtrsrvr
PropMtrcmd.cc : diag.cmd bmm.cmd
	cmdgen -o PropMtrcmd.cc diag.cmd bmm.cmd
PropMtrsrvroui.o : PropMtrsrvroui.cc
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) PropMtrsrvroui.cc
PropMtrsrvroui.cc : PropMtrsrvr.oui
	oui -o PropMtrsrvroui.cc PropMtrsrvr.oui
PropMtrsrvr.o : PropMtrcmd.cc
	$(CXX) -c -o PropMtrsrvr.o $(CPPFLAGS) $(CXXFLAGS) -DSERVER PropMtrcmd.cc
PropMtrsrvr : $(PROPMTRCMDOBJ) $(LIBDIR)/libdasio.a
	$(CXX) -o PropMtrsrvr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCMDOBJ) $(LDFLAGS) -lsubbuspp

PMKBDOBJ = PMkbd.o
OBJ += PMkbd
PMkbd : PMkbd.o $(LIBDIR)/libdasio.a
	$(CXX) -o PMkbd $(CPPFLAGS) $(CXXFLAGS) PMkbd.o $(LDFLAGS)

PROPMTRCOLOBJ = tmsrvr.o PropMtrcoloui.o
OBJ += PropMtrcol PropMtrcoloui.cc
DIST += PropMtrcol
PropMtrcol : $(PROPMTRCOLOBJ) $(LIBDIR)/libdasio.a
	$(CXX) -o PropMtrcol $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCOLOBJ) $(LDFLAGS)
PropMtrcoloui.o : PropMtrcoloui.cc
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) PropMtrcoloui.cc
PropMtrcoloui.cc : PropMtrcol.oui
	oui -o PropMtrcoloui.cc PropMtrcol.oui

PROPMTRCLTOBJ = PropMtrclt.o PropMtrcltoui.o
OBJ += PropMtrclt PropMtrcltoui.cc
DIST += PropMtrclt
PropMtrclt.o : PropMtrcmd.cc
	$(CXX) -c -o PropMtrclt.o $(CPPFLAGS) $(CXXFLAGS) -DCLIENT PropMtrcmd.cc
PropMtrcltoui.o : PropMtrcltoui.cc
PropMtrcltoui.cc : PropMtrclt.oui
	oui -o PropMtrcltoui.cc PropMtrclt.oui
PropMtrclt : $(PROPMTRCLTOBJ) $(LIBDIR)/libdasio.a
	$(CXX) -o PropMtrclt $(CPPFLAGS) $(CXXFLAGS) $(PROPMTRCLTOBJ) $(LDFLAGS) -lncurses

BMMDRVOBJ = bmm.o bmmoui.o
OBJ += bmmdrv bmmoui.cc
bmmoui.cc : bmm.oui
	oui -o bmmoui.cc bmm.oui
bmmdrv : $(BMMDRVOBJ)
	$(CXX) -o bmmdrv $(CPPFLAGS) $(CXXFLAGS) $(BMMDRVOBJ) $(LDFLAGS) -lsubbuspp

clean :
	rm -f $(OBJ)

distribution : $(DIST)
	scp $(DIST) $(TGT)
