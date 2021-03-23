include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS) -I ../PropMtr
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : PropMtrSim
OBJ = *.stackdump *.o

PROPMTROBJ = PropMtrSim.o PropMtrSimoui.o
OBJ += PropMtrSim PropMtrSimoui.cc
PropMtrSim : $(PROPMTROBJ) $(AG_LIBDIR)/libdasio.a
	$(CXX) -o PropMtrSim $(CPPFLAGS) $(CXXFLAGS) $(PROPMTROBJ) $(LDFLAGS)
PropMtrSimoui.o : PropMtrSimoui.cc
PropMtrSimoui.cc : PropMtrSim.oui
	oui -o PropMtrSimoui.cc PropMtrSim.oui

clean :
	rm -f $(OBJ)
