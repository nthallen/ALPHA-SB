#include <fcntl.h>
#include "ALPHA-SB.h"
#include "dualsim.h"
#include "crc16ccitt_false.h"

dualsim::dualsim(const char *port, int baud, ALPHA_SB *model)
  : DAS_IO::Serial("nav", 80, port, O_RDWR),
    model(model) {
  setup(baud, 8, 'n', 1, 1, 0);
}
  
bool dualsim::protocol_input() {
  if (model->Report(&tx.status)) {
    // Setup hdr
    tx.hdr.ID = 20; // system state
    tx.hdr.length = sizeof(tx.status);
    tx.hdr.CRC = crc16ccitt_false_word(0xFFFF,
      &tx.status, sizeof(tx.status));
    tx.hdr.LRC =
      -(tx.hdr.ID + tx.hdr.length + tx.hdr.CRC + (tx.hdr.CRC>>8));
    iwrite((const char *)&tx, sizeof(tx));
    model->Step();
    model->Log();
  }
  report_ok(nc);
  return false;
}
