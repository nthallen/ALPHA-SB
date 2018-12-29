/** @file PropMtr.h */
#include "dasio/client.h"
#include "PropMtr.h"

class PropMtrCmd : public DAS_IO::Client {
  public:
    PropMtrCmd();
    ~PropMtrCmd();
    bool app_input();
  protected:
};

