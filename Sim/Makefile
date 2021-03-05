#CPPFLAGS=-I /home/nort/Exp/SCoPEx/PORT/ode/pkg/usr/local/include \
#  -I /home/nort/Exp/SCoPEx/PORT/ode/include
#LDFLAGS=-L/home/nort/Exp/SCoPEx/PORT/ode/pkg/usr/local/lib -lode \
#	-L/home/nort/Exp/SCoPEx/PORT/ode/drawstuff/src -ldrawstuff \
#	-lGLU -lGL -L/usr/local/lib -lnort
LDFLAGS=-L/usr/local/lib -lode -lGLU -lGL -lnl 
MA_LDFLAGS=
CXXFLAGS=-g
CXXLD=$(CXX)
LIBTOOL=libtool
#CXXLINK = $(LIBTOOL) $(AM_V_lt) --tag=CXX $(AM_LIBTOOLFLAGS) \
#	$(LIBTOOLFLAGS) --mode=link $(CXXLD) $(AM_CXXFLAGS) \
#	$(CXXFLAGS) $(AM_LDFLAGS) $(LDFLAGS) -o $@
CXXLINK = $(CXXLD) $(CXXFLAGS) $(LDFLAGS)

.PHONY : all clean
all : scopex

scopex : scopex.o commandfile.o model_atmos.o
	$(CXXLD) -o scopex $(CXXFLAGS) scopex.o commandfile.o model_atmos.o $(LDFLAGS)
scopex.o : scopex.cc
commandfile.o : commandfile.cc

Sdebug : Sdebug.o
	$(CXXLINK) Sdebug.o
Sdebug.o : Sdebug.cc

clean :
	rm -f *.o Sdebug scopex
