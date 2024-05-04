#ifndef HALSA_INT_H_INCLUDED
#define HALSA_INT_H_INCLUDED

#include <math.h>
#include "dasio/interface.h"
#include "HALSA.h"

class UserPkts_UDP : public DAS_IO::Interface {
  public:
    UserPkts_UDP(int udp_port);
    bool protocol_input() override;
    bool process_eof() override;
  protected:
    bool tm_sync() override;
  private:
    void Bind(int port);
    int udp_port;
};

// class HALSA_Cmd : public DAS_IO::Cmd_reader {
  // public:
    // inline HALSA_Cmd() : DAS_IO::Cmd_reader("HALSA", 80, "HALSA") {}
    // bool app_input();
  // private:
    // void send_shutdown();
// };

#endif // HALSA_INT_H_INCLUDED
