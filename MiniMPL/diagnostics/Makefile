CXXFLAGS=-Wall -I/usr/local/include -g
LDFLAGS=-Wl,-rpath -Wl,/usr/local/lib -L/usr/local/lib -g
LIBS=-lsocket -lnort
.PHONY : all clean
all : UDPrcvr UDPsend

UDPrcvr : UDPrcvr.o
	$(LINK.cc) -o UDPrcvr UDPrcvr.o $(LIBS)
#	usemsg UDPrcvr UDPrcvroui.c
UDPrcvr.o : UDPrcvr.cc MiniMPL.h

UDPsend : UDPsend.o
	$(LINK.cc) -o UDPsend UDPsend.o $(LIBS)
UDPsend.o : UDPsend.cc MiniMPL.h

clean :
	rm -f UDPsend UDPrcvr *.o
