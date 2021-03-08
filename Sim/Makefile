LDFLAGS=-L/usr/local/lib -lode -lnl 
MA_LDFLAGS=
CXXFLAGS=-g
CXXLD=$(CXX)
LIBTOOL=libtool
CXXLINK = $(CXXLD) $(CXXFLAGS) $(LDFLAGS)

.PHONY : all clean
all : scopex

scopex : scopex.o commandfile.o model_atmos.o
	$(CXXLD) -o scopex $(CXXFLAGS) scopex.o commandfile.o model_atmos.o $(LDFLAGS)
scopex.o : scopex.cc
commandfile.o : commandfile.cc

clean :
	rm -f *.o scopex
