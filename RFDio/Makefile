include /usr/local/share/monarch/appgen.mk

CXXFLAGS+=-g -Wall -std=c++11 $(CPPFLAGS)
LDFLAGS=$(AG_LDFLAGS) -ldasio -lnl -lpthread

.PHONY : all
all : RFDio
OBJ = *.stackdump *.o

RFDioOBJ = RFDio.o RFDiooui.o
OBJ += RFDio RFDiooui.cc
DIST += RFDio
RFDio : $(RFDioOBJ)
	$(CXX) -o RFDio $(CPPFLAGS) $(CXXFLAGS) $(RFDioOBJ) $(LDFLAGS)
RFDio.o : RFDio.cc RFDio_int.h
RFDiooui.o : RFDiooui.cc
RFDiooui.cc : RFDio.oui
	oui -o RFDiooui.cc RFDio.oui

clean :
	rm -f $(OBJ)
