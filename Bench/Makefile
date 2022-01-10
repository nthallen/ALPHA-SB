PHONY : all clean
include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

all : BKd
OBJ = *.stackdump *.o

BKDOBJ = BKmain.o BKdev.o BKdoui.o rqueue.o
OBJ += BKd BKdoui.cc
BKd : $(BKDOBJ) $(AG_LIBDIR)/libdasio.a
	$(CXX) -o BKd $(CXXFLAGS) $(BKDOBJ) $(LDFLAGS)
BKdoui.o : BKdoui.cc
BKdoui.cc : BKd.oui
	oui -o BKdoui.cc $<

clean :
	rm -f $(OBJ)
