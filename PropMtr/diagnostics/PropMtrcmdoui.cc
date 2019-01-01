/* OUI output from the following packages:
   PropMtrcmd
*/
#include "oui.h"
#include "dasio/appid.h"
const char *opt_string = "";
  DAS_IO::AppID_t DAS_IO::AppID("PropMtrcmd", "Propeller Motor Controller Command Server", "V1.0");

void oui_init_options(int argc, char **argv) {
}

#ifdef __USAGE
%C    [options]
#endif
