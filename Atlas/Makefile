include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS)
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : Ascender
OBJ = *.stackdump *.o

ASCENDEROBJ = Ascender.o Ascenderoui.o
OBJ += Ascender Ascenderoui.cc
DIST += Ascender
Ascender : $(ASCENDEROBJ) $(AG_LIBDIR)/libdasio.a
	$(CXX) -o Ascender $(CPPFLAGS) $(CXXFLAGS) $(ASCENDEROBJ) $(LDFLAGS)
Ascender.o : Ascender.cc
Ascenderoui.o : Ascenderoui.cc
Ascenderoui.cc : Ascender.oui
	oui -o Ascenderoui.cc Ascender.oui

clean :
	rm -f $(OBJ)
