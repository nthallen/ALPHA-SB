#include <fcntl.h>
#include "dasio/loop.h"
#include "SDual_int.h"
#include "oui.h"

using namespace DAS_IO;

system_state_t SpatialDual;
const char *SDual_port = "/dev/ttyS0";
int SDual_baud = 115200;

SDual::SDual(const char *path)
    : Serial("SDual", 500, path, O_RDWR) {
  setup(SDual_baud, 8, 'n', 1, 100, 1);
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  msg(0, "Starting");
  Loop ELoop;
  ELoop.add_child(new Quit());
  ELoop.add_child(new
    TM_data_sndr("TM", 0, &SpatialDual, sizeof(SpatialDual)));
  ELoop.add_child(new SDual(SDual_port));
  ELoop.event_loop();
  msg(0, "Terminating");
  return 0;
}
