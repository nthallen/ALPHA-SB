CXXFLAGS=-Wall -I/usr/local/include
LDFLAGS=-Wl,-rpath -Wl,/usr/local/lib -L/usr/local/lib
LIBS=-lsocket -lnort

UDPrcvr : UDPrcvr.o
	$(LINK.cc) -o UDPrcvr UDPrcvr.o $(LIBS)
#	usemsg UDPrcvr UDPrcvroui.c
UDPrcvr.o : UDPrcvr.cc MiniMPL.h
