#include <fcntl.h>
#include "ALPHA-SB.h"
#include "dualsimsock.h"
#include "crc16ccitt_false.h"

dualsim::dualsim(ALPHA_SB *model)
  : DAS_IO::Client("nav", "nav", "sdual", 0, 80),
    model(model) {
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
