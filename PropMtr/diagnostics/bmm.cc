/** @file test_bmm.cc
 * @brief Test interfaces to subbus modules
 */
#include <stdio.h>
#include <unistd.h>
#include "dasio/appid.h"
#include "oui.h"
#include "subbuspp.h"
#include "nl.h"

DAS_IO::AppID_t DAS_IO::AppID("BMM", "BMM Test Program", "V1.0");

typedef struct {
  uint16_t n_words;
  char name[0x50];
} device_name_t;

/* Conversion factors for output in Volts and Amps */
#define VCONV (0.025/16)
#define ICONV28 (20e-3/(16*7))
#define ICONV50 (20e-3/(16*3))
#define ADINCONV28 ((0.5e-3 * (2+29.4))/(16*2))
#define ADINCONV50 ((0.5e-3 * (2+59.0))/(16*2))

void identify_board(subbuspp *P, uint8_t bdid) {
  uint16_t bdid_hi = bdid<<8;
  // msg(0,"read_ack(0x%02X03)", bdid);
  uint16_t value;
  if (! P->read_ack(bdid_hi | 0x03, &value)) {
    msg(2, "No acknowledge from board %d", bdid);
    return;
  }
  uint16_t build = P->read_subbus(bdid_hi | 0x02);
  msg(0, "  Board ID:%d Type:%d S/N:%d Build:%d", bdid, value>>8, value & 0xFF, build);
  
  char mreqstr[30];
  snprintf(mreqstr, 30, "%X|28@%X", bdid_hi|6, bdid_hi|7);
  subbus_mread_req *mreq = P->pack_mread_request(0x29, mreqstr);
  device_name_t devname;
  uint16_t nread;
  int rv = P->mread_subbus_nw(mreq, (uint16_t*)&devname, &nread);
  if (rv < 0) {
    msg(2, "Error %d from mread", rv);
  } else {
    msg(0, "nr:%u/%u '%s'", nread, devname.n_words, &devname.name[0]);
  }
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  subbuspp *P = new subbuspp("subbusd", "CAN");
  int subfunc = P->load();
  if (subfunc) {
    msg(0, "Subbus subfunction %d, name %s", subfunc, P->get_subbus_name());
  } else {
    msg(3, "Failed to connect with subbus");
  }

  identify_board(P, 1);
  identify_board(P, 2);
  
  for (;;) {
    sleep(1);
    uint16_t PM0I1 = P->read_subbus(0x0121);
    uint16_t PM0V1 = P->read_subbus(0x0122);
    uint16_t PM0V2 = P->read_subbus(0x0123);
    uint16_t PM1I1 = P->read_subbus(0x0221);
    uint16_t PM1V1 = P->read_subbus(0x0222);
    uint16_t PM1V2 = P->read_subbus(0x0223);
    msg(0, "BMM: V01:%5.2lf V V02:%5.2lf V I0:%6.3lf A"
           " V11:%5.2lf V V12:%5.2lf V I1:%6.3lf A",
            PM0V1*VCONV, PM0V2*ADINCONV50, PM0I1*ICONV50,
            PM1V1*VCONV, PM1V2*ADINCONV50, PM1I1*ICONV50);
  }
  return 0;
}
