CXXFLAGS = -Wall -g -std=c++11 -D_DEFAULT_SOURCE
LDFLAGS = -L/usr/local/lib -ldasio -lnl -lpthread
.PHONY : clean

HALSA : halsa.o halsaoui.o
	$(CXX) -o HALSA $(CXXFLAGS) halsa.o halsaoui.o $(LDFLAGS)
halsaoui.o : halsaoui.cc
halsaoui.cc : halsa.oui
	oui -o halsaoui.cc halsa.oui
clean :
	rm -f HALSA halsaoui.cc *.o
