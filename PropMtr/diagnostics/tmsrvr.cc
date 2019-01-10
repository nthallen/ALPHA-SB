/* TM server example */
#include <string.h>
#include "dasio/tm_server.h"
#include "dasio/quit.h"
#include "dasio/loop.h"
#include "dasio/appid.h"
#include "PropMtr.h"
#include "nl.h"

using namespace DAS_IO;

PropMtr_t PropMtr;
TM_data_rcvr_def PropMtr_obj("PropMtr", &PropMtr, sizeof(PropMtr));

class my_tm_data_rcvr : public TM_data_rcvr {
  public:
    my_tm_data_rcvr(Authenticator *auth, const char *iname, TM_data_rcvr_def *def);
    ~my_tm_data_rcvr();
    static TM_data_rcvr *new_my_tm_data_rcvr(Authenticator *auth, SubService *ss);
    bool protocol_input();
    bool protocol_timeout();
    bool connected();
};

my_tm_data_rcvr::my_tm_data_rcvr(Authenticator *auth, const char *iname,
    TM_data_rcvr_def *def) : TM_data_rcvr(auth, iname, def) {}

my_tm_data_rcvr::~my_tm_data_rcvr() {}

TM_data_rcvr *my_tm_data_rcvr::new_my_tm_data_rcvr(Authenticator *auth, SubService *ss) {
    // Set iname from client_app and datum
    const char *clt_app = auth->get_client_app();
    TM_data_rcvr_def *def = (TM_data_rcvr_def *)(ss->svc_data);
    int inamelen = strlen(clt_app) + strlen(def->datum) + 2;
    char *iname = (char *)new_memory(inamelen);
    snprintf(iname, inamelen, "%s/%s", clt_app, def->datum);
    return new my_tm_data_rcvr(auth, iname, def);
}

bool my_tm_data_rcvr::protocol_input() {
  if (nc < sizeof(PropMtr)) return false;
  if (TM_data_rcvr::protocol_input()) return true;
  uint16_t *S = &PropMtr.Ctrl[0].Status[0];
  nl_error(0, "S:%04X %04X %04X %04X %04X %04X %04X %6.2lf %8.3lf %8.3lf %8d %8d %8d",
    S[0], S[1], S[2], S[3], S[4], S[5], S[6],
    PropMtr.Ctrl[0].BusVoltage * 1.05 * 195. / 16384,
    PropMtr.Ctrl[0].VelocityDemand * 75. / 65536.,
    PropMtr.Ctrl[0].VelocityMeasured * 74. / 65536.,
    PropMtr.Ctrl[0].PositionTarget,
    PropMtr.Ctrl[0].PositionDemand,
    PropMtr.Ctrl[0].PositionMeasured);
  // nl_error(0, "TO: %s, flags: %d",
    // TO.Expired() ? "Expired" : TO.Set() ? "Pending" : "Clear", flags);
  return false;
}

bool my_tm_data_rcvr::connected() {
  TO.Set(1, 0);
  return false;
}

bool my_tm_data_rcvr::protocol_timeout() {
  // nl_error(0, "%s: timeout: sending synch", iname);
  synch();
  TO.Set(1, 0);
  return false;
}

const char *opt_string = "vo:mV";

AppID_t DAS_IO::AppID("tmsrvr", "Prop Mtr Test TM Server", "V1.0");

int main(int argc, char **argv) {
  DAS_IO::Quit Q;
  Server S("DG", 128);
  S.Subs.add_subservice(
    new SubService(
      "DG/data/PropMtr",
      (socket_clone_t)my_tm_data_rcvr::new_my_tm_data_rcvr,
      &PropMtr_obj
    )
  );
  Q.connect();
  S.ELoop.add_child(&Q);
  S.Start(Server::Srv_Unix);
  return 0;
}
