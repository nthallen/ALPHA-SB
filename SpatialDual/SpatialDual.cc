#include <fcntl.h>
#include "dasio/loop.h"
#include "dasio/quit.h"
#include "dasio/tm_data_sndr.h"
#include "nl.h"
#include "nl_assert.h"
#include "SDual_int.h"
#include "oui.h"
#include "crc16ccitt_false.h"

using namespace DAS_IO;

system_state_t SpatialDual;
const char *SDual_port = "/dev/ttyS0";
int SDual_baud = 115200;
bool SDual_sim = false;

SDual::SDual(const char *port, TM_data_sndr *TM)
    : Serial("SDual", 500, port, O_RDWR),
      TM(TM) {
  setup(SDual_baud, 8, 'n', 1, 17, 1);
  flags |= gflag(0);
  update_tc_vmin(0,0);
  flush_input();
  update_tc_vmin(17,1);
}

bool SDual::protocol_input() {
  uint8_t LRC = 0;
  int LRC_count = 0;
  // cp will point to the start of the hdr
  for (LRC_count = 0; cp+LRC_count < nc; ) {
    if (LRC_count < 5) {
      LRC += buf[cp+LRC_count++];
    } else {
      LRC += buf[cp+5] - buf[cp];
      ++cp;
    }
    if (LRC_count >= 5 && LRC == 0) {
      hdr = (frame_hdr_t*)&buf[cp];
      if (cp+sizeof(frame_hdr_t)+hdr->Packet_len > nc) {
        // update_tc_vmin(cp+sizeof(frame_hdr_t)+hdr->Packet_len-nc)
        break;
      }
      // Check packet CRC
      // The CRC is a CRC16-CCITT.
      // The starting value is 0xFFFF.
      // The CRC covers only the packet data.
      uint16_t CRC = crc16ccitt_false_word(0xFFFF,
                      &buf[cp+sizeof(frame_hdr_t)], hdr->Packet_len);
      if (CRC != hdr->CRC) {
        msg(MSG_ERROR, "%s: CRC hdr:%04X pkt:%04X",
              iname, hdr->CRC, CRC);
        // I could discard the minimum, assuming a failure
        // could be due to dropped bytes. This would
        // generate more noise when the current packet
        // ultimately gets discarded, but ensure that
        // if we are misaligned, we have a chance to
        // recover.
      } else {
        msg(MSG_DBG(1),
          "Packet Located at offset %5d: LRC:%02X ID:%3u Len:%3u CRC:%5u",
          cp, hdr->LRC, hdr->Packet_ID, hdr->Packet_len, hdr->CRC);
        switch (hdr->Packet_ID) {
          case 20: // System State
            if (report_system_state((system_status_t*)&buf[cp+sizeof(frame_hdr_t)]))
              return true;
            break;
          case 25: // Velocity Standard Deviation
          case 26: // Orientation Standard Deviation
          case 28: // Raw sensors packet (probably not interested)
          case 30: // Satelittes
          case 43: // Angular Acceleration
            break;
          default:
            msg(0, "Unsupported packet type %d", hdr->Packet_ID);
            break;
        }
      }
      if (cp > 0)
        msg(MSG_WARN, "Discarded %u bytes before packet", cp);
      cp += sizeof(frame_hdr_t) + hdr->Packet_len;
      report_ok(cp);
      LRC = 0;
      LRC_count = 0;
      // update_tc_vmin(17-nc);
    }
  }
  if (cp > 0)
    msg(MSG_DEBUG, "Discarding %d chars", cp);
  report_ok(cp);
  if (LRC_count >= 5 && LRC == 0) {
    nl_assert(nc >= 5);
    hdr = (frame_hdr_t*)&buf[cp];
    nl_assert(nc < cp+sizeof(frame_hdr_t) + hdr->Packet_len);
    update_tc_vmin(cp+sizeof(frame_hdr_t) + hdr->Packet_len - nc);
  } else {
    nl_assert(cp == 0 && nc < 17);
    update_tc_vmin(17-nc+cp);
  }
  return false;
}

bool SDual::report_system_state(system_status_t *recd) {
  SpatialDual.SD = *recd;
  SpatialDual.nc = nc;
  ++SpatialDual.n_reports;
  return false;
}

bool SDual::tm_sync() {
  SpatialDual.n_reports = 0;
  if (SDual_sim && obuf_empty()) iwrite("\n", 1);
  return false;
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  msg(0, "Starting");
  Loop ELoop;
  { Quit *Q = new Quit();
    Q->connect();
    ELoop.add_child(Q);
  }
  { TM_data_sndr *TM = new
      TM_data_sndr("TM", 0, "SpatialDual",
          &SpatialDual, sizeof(SpatialDual));
    TM->connect();
    ELoop.add_child(TM);
    ELoop.add_child(new SDual(SDual_port, TM));
  }
  ELoop.event_loop();
  msg(0, "Terminating");
  return 0;
}
