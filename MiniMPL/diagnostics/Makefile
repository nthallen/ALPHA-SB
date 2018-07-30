CXXFLAGS=-Wall -I/usr/local/include
LDFLAGS=-Wl,-rpath -Wl,/usr/local/lib -L/usr/local/lib
LIBS=-lsocket -lnort
.PHONY : all clean
all : UDPrcrv UDPsend

UDPrcvr : UDPrcvr.o
	$(LINK.cc) -o UDPrcvr UDPrcvr.o $(LIBS)
#	usemsg UDPrcvr UDPrcvroui.c
UDPrcvr.o : UDPrcvr.cc MiniMPL.h

UDPsend : UDPsend.o
	$(LINK.cc) -o UDPsend UDPsend.o $(LIBS)
UDPsend.o : UDPsend.cc MiniMPL.h

clean :
	rm -f UDPsend UDPrcvr *.o
