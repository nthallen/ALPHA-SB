#include <fcntl.h>
#include "dasio/loop.h"
#include "dasio/quit.h"
#include "dasio/tm_data_sndr.h"
#include "nl.h"
#include "nl_assert.h"
#include "SDual_sim.h"
#include "oui.h"
#include "crc16ccitt_false.h"

using namespace DAS_IO;

system_state_t SpatialDual;
bool SDual_sim = true;

TM_data_sndr *SDual::TM;

SDual::SDual(Authenticator *Auth, const char *iname)
    : Serverside_client(Auth, iname, 500) {
  flags |= gflag(0);
}

bool SDual::protocol_input() {
  uint8_t LRC = 0;
  int LRC_count = 0;
  int expected_pkt_size;
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
      switch (hdr->Packet_ID) {
        case 20: expected_pkt_size = 100; break;// System State
        case 25: expected_pkt_size = 12; break; // Velocity Standard Deviation
        case 26: expected_pkt_size = 12; break; // Orientation Standard Deviation
        case 28: expected_pkt_size = 48; break; // Raw sensors packet (probably not interested)
        case 30: expected_pkt_size = 13; break; // Satelittes
        case 43: expected_pkt_size = 12; break; // Angular Acceleration
        default: expected_pkt_size = 0; break;
      }
      if (expected_pkt_size == 0) {
        msg(MSG_DBG(1), "%s: Unexpected packet ID %d", iname, hdr->Packet_ID);
        expected_pkt_size = 0;
      } else if (hdr->Packet_len != expected_pkt_size) {
        msg(MSG_DBG(1), "%s: ID %d expected length %d hdr", iname,
              hdr->Packet_ID, expected_pkt_size, hdr->Packet_len);
        expected_pkt_size = 0;
      } else {
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
  }
  if (cp > 0)
    msg(MSG_DEBUG, "Discarding %d chars", cp);
  report_ok(cp);
  if (LRC_count >= 5 && LRC == 0 && expected_pkt_size > 0) {
    nl_assert(nc >= 5);
    hdr = (frame_hdr_t*)&buf[cp];
    nl_assert(nc < cp+sizeof(frame_hdr_t) + hdr->Packet_len);
    // update_tc_vmin(cp+sizeof(frame_hdr_t) + hdr->Packet_len - nc);
  } else {
    nl_assert(cp == 0 && nc < 17);
    // update_tc_vmin(17-nc+cp);
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

SDual *new_SDual_socket(Authenticator *Auth,SubService *SS) {
  SS = SS; // No need for this
  return new SDual(Auth, Auth->get_client_app());
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  msg(0, "Starting");
  Server server("sdual");
  server.add_subservice(new SubService("sdual", (socket_clone_t)new_SDual_socket, (void*)0));
  { Quit *Q = new Quit();
    Q->connect();
    server.ELoop.add_child(Q);
  }
  { TM_data_sndr *TM = new
      TM_data_sndr("TM", 0, "SpatialDual",
          &SpatialDual, sizeof(SpatialDual));
    TM->connect();
    server.ELoop.add_child(TM);
    SDual::set_TM(TM);
    // server.ELoop.add_child(new SDual(SDual_port, TM));
  }
  server.Start(Server::Srv_Function, "SDualSim");
  msg(0, "Terminating");
  return 0;
}
