include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS)
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : SpatialDual SpatialDualSim
OBJ = *.stackdump *.o

SPATIALDUALOBJ = SpatialDual.o SpatialDualoui.o crc16ccitt_false.o
SPATIALDUALSIMOBJ = SpatialDualSim.o SpatialDualSimoui.o crc16ccitt_false.o
OBJ += SpatialDual SpatialDualoui.cc
OBJ += SpatialDualSim SpatialDualouiSim.cc
DIST += SpatialDual SpatialDualSim
SpatialDual : $(SPATIALDUALOBJ)
	$(CXX) -o SpatialDual $(CPPFLAGS) $(CXXFLAGS) $(SPATIALDUALOBJ) $(LDFLAGS)
SpatialDual.o : SpatialDual.cc SDual_int.h SpatialDual.h
SpatialDualoui.o : SpatialDualoui.cc
SpatialDualoui.cc : SpatialDual.oui
	oui -o SpatialDualoui.cc SpatialDual.oui

SpatialDualSim : $(SPATIALDUALSIMOBJ)
	$(CXX) -o SpatialDualSim $(CPPFLAGS) $(CXXFLAGS) $(SPATIALDUALSIMOBJ) $(LDFLAGS)
SpatialDualSim.o : SpatialDualSim.cc SDual_sim.h SpatialDual.h
SpatialDualSimoui.o : SpatialDualSimoui.cc
SpatialDualSimoui.cc : SpatialDualSim.oui
	oui -o SpatialDualSimoui.cc SpatialDualSim.oui

clean :
	rm -f $(OBJ)
