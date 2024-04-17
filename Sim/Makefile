LDFLAGS=-L/usr/local/lib -lode -ldasio -lnl -lpthread
MA_LDFLAGS=
CXXFLAGS=-g -I../SpatialDual
CXXLD=$(CXX)
LIBTOOL=libtool
OBJ = alpha-sb.o commandfile.o model_atmos.o alpha-sb-simoui.o dualsim.o
OBJ += crc16ccitt_false.o

.PHONY : all clean
all : alpha-sb-sim alpha-sb-simsock

alpha-sb-sim : $(OBJ)
	$(CXXLD) -o alpha-sb-sim $(CXXFLAGS) $(OBJ) $(LDFLAGS)
alpha-sb-simoui.o : alpha-sb-simoui.cc
alpha-sb-simoui.cc : alpha-sb-sim.oui
	oui -o alpha-sb-simoui.cc alpha-sb-sim.oui
crc16ccitt_false.o : ../SpatialDual/crc16ccitt_false.cc
	$(CXX) $(CSSFLAGS) -c -o crc16ccitt_false.o ../SpatialDual/crc16ccitt_false.cc

SOCKOBJ = alpha-sb-sock.o commandfile.o model_atmos.o alpha-sb-simsockoui.o dualsimsock.o
SOCKOBJ += crc16ccitt_false.o
alpha-sb-simsock : $(SOCKOBJ)
	$(CXXLD) -o alpha-sb-simsock $(CXXFLAGS) $(SOCKOBJ) $(LDFLAGS)
alpha-sb-simsockoui.o : alpha-sb-simsockoui.cc
alpha-sb-simsockoui.cc : alpha-sb-simsock.oui
	oui -o alpha-sb-simsockoui.cc alpha-sb-simsock.oui

clean :
	rm -f *.o alpha-sb-sim alpha-sb-simsock *oui.cc
