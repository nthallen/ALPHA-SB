include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lsubbuspp -lpthread

.PHONY : all
all : ICM20948
OBJ = *.stackdump *.o

ICM20948OBJ = ICM20948.o ICM20948oui.o
OBJ += ICM20948 ICM20948oui.cc
ICM20948 : $(ICM20948OBJ) $(AG_LIBDIR)/libdasio.a
	$(CXX) -o ICM20948 $(CXXFLAGS) $(ICM20948OBJ) $(LDFLAGS)
ICM20948.o : ICM20948.cc ICM20948_drv.h ICM20948.h
ICM20948oui.o : ICM20948oui.cc ICM20948_drv.h ICM20948.h
ICM20948oui.cc : ICM20948.oui
	oui -o ICM20948oui.cc $<

clean :
	rm -f $(OBJ)
