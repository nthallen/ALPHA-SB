LDFLAGS=-L/usr/local/lib -lode -ldasio -lnl -lpthread
MA_LDFLAGS=
CXXFLAGS=-g -I../SpatialDual
CXXLD=$(CXX)
LIBTOOL=libtool
OBJ = scopex.o commandfile.o model_atmos.o scopexsimoui.o dualsim.o
OBJ += crc16ccitt_false.o

.PHONY : all clean
all : scopexsim

scopexsim : $(OBJ)
	$(CXXLD) -o scopexsim $(CXXFLAGS) $(OBJ) $(LDFLAGS)
scopexsimoui.o : scopexsimoui.cc
scopexsimoui.cc : scopexsim.oui
	oui -o scopexsimoui.cc scopexsim.oui
crc16ccitt_false.o : ../SpatialDual/crc16ccitt_false.cc
	$(CXX) $(CSSFLAGS) -c -o crc16ccitt_false.o ../SpatialDual/crc16ccitt_false.cc

clean :
	rm -f *.o scopex
