ifdef CROSS_COMPILING
CPPFLAGS += -I/opt/linkeng/am335x/include
LIBDIR = /opt/linkeng/am335x/lib
else
LIBDIR = /usr/local/lib
endif

CXXFLAGS += -g -Wall -std=c++11
LDFLAGS = -L$(LIBDIR) -ldasio -lnl -ltm

.PHONY : all
all : PropMtr
OBJ = *.stackdump *.o
TGT = $(tgt):/home/flight

PROPMTROBJ = PropMtr.o PropMtroui.o pmc.o
OBJ += PropMtr PropMtroui.cc
DIST += PropMtr
PropMtr : $(PROPMTROBJ) $(LIBDIR)/libdasio.a
	$(CXX) -o PropMtr $(CPPFLAGS) $(CXXFLAGS) $(PROPMTROBJ) $(LDFLAGS)
PropMtr.o : PropMtr.cc
PropMtroui.o : PropMtroui.cc
PropMtroui.cc : PropMtr.oui
	oui -o PropMtroui.cc PropMtr.oui

clean :
	rm -f $(OBJ)

distribution : $(DIST)
	scp $(DIST) $(TGT)
