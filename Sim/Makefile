LDFLAGS=-L/usr/local/lib -lode -ldasio -lnl 
MA_LDFLAGS=
CXXFLAGS=-g
CXXLD=$(CXX)
LIBTOOL=libtool
CXXLINK = $(CXXLD) $(CXXFLAGS) $(LDFLAGS)
OBJ = scopex.o commandfile.o model_atmos.o scopexsimoui.o

.PHONY : all clean
all : scopex

scopex : $(OBJ)
	$(CXXLD) -o scopex $(CXXFLAGS) $(OBJ) $(LDFLAGS)
scopex.o : scopex.cc
commandfile.o : commandfile.cc
scopexsimoui.o : scopexsimoui.cc
scopexsimoui.cc : scopexsim.oui
	oui -o scopexsimoui.cc scopexsim.oui

clean :
	rm -f *.o scopex
