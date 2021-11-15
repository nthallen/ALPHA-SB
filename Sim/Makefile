LDFLAGS=-L/usr/local/lib -lode -ldasio -lnl -lpthread
MA_LDFLAGS=
CXXFLAGS=-g -I../SpatialDual
CXXLD=$(CXX)
LIBTOOL=libtool
OBJ = scopex.o commandfile.o model_atmos.o scopexsimoui.o dualsim.o
OBJ += crc16ccitt_false.o

.PHONY : all clean
all : scopexsim scopexsimsock

scopexsim : $(OBJ)
	$(CXXLD) -o scopexsim $(CXXFLAGS) $(OBJ) $(LDFLAGS)
scopexsimoui.o : scopexsimoui.cc
scopexsimoui.cc : scopexsim.oui
	oui -o scopexsimoui.cc scopexsim.oui
crc16ccitt_false.o : ../SpatialDual/crc16ccitt_false.cc
	$(CXX) $(CSSFLAGS) -c -o crc16ccitt_false.o ../SpatialDual/crc16ccitt_false.cc

SOCKOBJ = scopexsock.o commandfile.o model_atmos.o scopexsimsockoui.o dualsimsock.o
SOCKOBJ += crc16ccitt_false.o
scopexsimsock : $(SOCKOBJ)
	$(CXXLD) -o scopexsimsock $(CXXFLAGS) $(SOCKOBJ) $(LDFLAGS)
scopexsimsockoui.o : scopexsimsockoui.cc
scopexsimsockoui.cc : scopexsimsock.oui
	oui -o scopexsimsockoui.cc scopexsimsock.oui

clean :
	rm -f *.o scopexsim scopexsimsock *oui.cc
