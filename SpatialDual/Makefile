include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS)
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : SpatialDual SpatialDualSock
OBJ = *.stackdump *.o

SPATIALDUALOBJ = SpatialDual.o SpatialDualoui.o crc16ccitt_false.o
SPATIALDUALSIMOBJ = SpatialDualSock.o SpatialDualSockoui.o crc16ccitt_false.o
OBJ += SpatialDual SpatialDualoui.cc
OBJ += SpatialDualSock SpatialDualSockoui.cc
DIST += SpatialDual SpatialDualSock
SpatialDual : $(SPATIALDUALOBJ)
	$(CXX) -o SpatialDual $(CPPFLAGS) $(CXXFLAGS) $(SPATIALDUALOBJ) $(LDFLAGS)
SpatialDual.o : SpatialDual.cc SDual_int.h SpatialDual.h
SpatialDualoui.o : SpatialDualoui.cc
SpatialDualoui.cc : SpatialDual.oui
	oui -o SpatialDualoui.cc SpatialDual.oui

SpatialDualSock : $(SPATIALDUALSIMOBJ)
	$(CXX) -o SpatialDualSock $(CPPFLAGS) $(CXXFLAGS) $(SPATIALDUALSIMOBJ) $(LDFLAGS)
SpatialDualSock.o : SpatialDualSock.cc SDual_sock.h SpatialDual.h
SpatialDualSockoui.o : SpatialDualSockoui.cc
SpatialDualSockoui.cc : SpatialDualSock.oui
	oui -o SpatialDualSockoui.cc SpatialDualSock.oui

clean :
	rm -f $(OBJ)
