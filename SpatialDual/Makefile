include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS)
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : SpatialDual
OBJ = *.stackdump *.o

SPATIALDUALOBJ = SpatialDual.o SpatialDualoui.o crc16ccitt_false.o
OBJ += SpatialDual SpatialDualoui.cc
DIST += SpatialDual
SpatialDual : $(SPATIALDUALOBJ)
	$(CXX) -o SpatialDual $(CPPFLAGS) $(CXXFLAGS) $(SPATIALDUALOBJ) $(LDFLAGS)
SpatialDual.o : SpatialDual.cc SDual_int.h SpatialDual.h
SpatialDualoui.o : SpatialDualoui.cc
SpatialDualoui.cc : SpatialDual.oui
	oui -o SpatialDualoui.cc SpatialDual.oui

clean :
	rm -f $(OBJ)
