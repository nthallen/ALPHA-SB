/* ICM20948.cc */
#include <stdio.h>
#include "ICM20948_drv.h"
#include "dasio/appid.h"
#include "oui.h"
#include "subbuspp.h"
#include "nl.h"

using namespace DAS_IO;

ICM20948_t ICM20948;
const char *ICM_dev::subbusd_service = "subbusd";

ICM_dev::ICM_dev(Loop *ELoop)
    : Interface("ICM", 0),
      quit_requested(false),
      cmd_modefs(0), req_modefs(0), rep_modefs(0),
      req_mode(0), req_fs(0),
      Fsample(566) {
  SB = new subbuspp(subbusd_service, "serusb"); // for now
  ELoop->add_child(this);
  flags = gflag(0);
}

void ICM_dev::set_mode(uint8_t mode) {
  if (mode > 2)
    msg(MSG_ERROR, "%s: Invalid mode code: %d", iname, mode);
  else req_mode = mode;
}

void ICM_dev::set_fs(uint8_t fs) {
  if (fs > 3)
    msg(MSG_ERROR, "%s: Invalid full scale code: %d", iname, fs);
  else
    req_fs = fs;
}

void ICM_dev::Quit() {
  quit_requested = true;
}

void ICM_dev::read_sensors() {
}

void ICM_dev::read_modes() {
  uint16_t data[2];
  for (int i = 0; i < N_ICM20948_SENSORS; ++i) {
    SB->mread_subbus(rm_idle[i], data);
    ICM20948.dev[i].mode = mask_mode(data[0]);
    ICM20948.dev[i].fs = mask_fs(data[0]);
  }
}

void ICM_dev::prep_multiread() {
  char prepbuf[80];
  
  for (int i = 0; i < N_ICM20948_SENSORS; ++i) {
    uint16_t base = base_addr[i];
    rm_idle[i] =
      SB->pack_mread_requests(base+0x64, base+0x65, 0);
    snprintf(prepbuf, 80, "%X,%X|1EF@%X", base+0x64, base+0x65, base+0x66);
    rm_fifo[i] =
      SB->pack_mread_request(497, prepbuf);
  }
}

uint16_t ICM_dev::base_addr[N_ICM20948_SENSORS] = { 0 };

void ICM_dev::event_loop() {
  int subfunc = SB->load();
  if (subfunc)
    msg(MSG, "%s: Connected to %s", iname, SB->get_subbus_name());
  else
    msg(MSG_FATAL, "%s: Unable to load subbus", iname);
  prep_multiread();

  while (!quit_requested) {
    req_modefs = mask_modefs(req_mode, req_fs);
    if (req_modefs != rep_modefs) {
      if (mask_mode(rep_modefs) == 0) {
        // Now we can command the new mode
        if (mask_mode(cmd_modefs) == 0) {
          report_err("%s: Previous mode 0 command not completed", iname);
        }
        if (req_fs != mask_fs(rep_modefs)) {
          SB->write_ack(uDACS_cmd_addr, uDACS_fs_cmd_offset+req_fs);
        }
        SB->write_ack(uDACS_cmd_addr, uDACS_mode_cmd_offset+req_mode);
        cmd_modefs = req_modefs;
      } else {
        // rep_mode not zero, need to command it
        if (mask_mode(cmd_modefs) == 0) {
          report_err("%s: Expected mode zero", iname);
        } else {
          SB->write_ack(uDACS_cmd_addr, uDACS_mode_cmd_offset+0);
          cmd_modefs = mask_modefs(0, mask_fs(rep_modefs));
        }
      }
    } else if (req_mode == 2) {
      read_sensors();
    } else {
      read_modes();
    }
    ELoop->event_loop();
  }
}

bool ICM_dev::tm_sync() {
  return true;
}

ICM_cmd_t::ICM_cmd_t(ICM_dev *ICM)
    : Cmd_reader("cmd", 20, "ICM20948"),
      ICM(ICM) {}

/**
 * Accepts the following commands from the command server:
 *  - M[0-2] : Select mode 0, 1 or 2
 *  - F[0-3] : Select full scale sensor range. Fn => 2^(n+1) g
 *  - Q      : Quit
 */
bool ICM_cmd_t::protocol_input() {
  uint8_t MF_val;
  if (nc > 0) {
    unsigned char cmd = buf[cp];
    if (cmd == 'Q') {
      msg(MSG_DEBUG, "Received Quit");
      report_ok(nc);
      ICM->Quit();
      return true;
    } else if (not_any("MF") || not_uint8(MF_val) || not_str("\n")) {
      if (cp >= nc)
        report_err("%s: incomplete command", iname);
      consume(nc);
    } else {
      if (cmd == 'M') ICM->set_mode(MF_val);
      else ICM->set_fs(MF_val);
      report_ok(nc);
    }
  }
  return false;
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  { Loop ELoop;
    
    AppID.report_startup();
    
    ICM_dev *ICM = new ICM_dev(&ELoop);

    ICM_cmd_t *ICM_cmd = new ICM_cmd_t(ICM);
    ELoop.add_child(ICM_cmd);
    ICM_cmd->connect();
    
    TM_data_sndr *ICM_TM =
      new TM_data_sndr("TM",0,"ICM20948", &ICM20948, sizeof(ICM20948));
    ELoop.add_child(ICM_TM);
    ICM_TM->connect();
    
    ICM->event_loop();
    ELoop.delete_children();
    ELoop.clear_delete_queue();
    AppID.report_shutdown();
  }
}
