#include "dasio/loop.h"
#include "dasio/tm_data_sndr.h"
#include "Ascender_int.h"
#include "nl.h"
#include "oui.h"

ascender_t Ascender;
const char *Ascend::Ascender_port;

Ascend::Ascend(const char *iname)
    : Serial(iname, 80, Ascender_port, O_RDWR|O_NONBLOCK),
      cur_percent(0) {
  setup(115200, 8, 'n', 1, -1, 0);
  set_obufsize(32);
  flags |= gflag(0) | Fl_Timeout;
}

bool Ascend::SetSpeed(int32_t percent) {
  bool rv = false;
  if (percent > 100 || percent < -100) {
    msg(2, "%s: Speed command value %d out of range",
      iname, percent);
  } else if (obuf_empty()) {
    msg(MSG_DEBUG, "%s: SetSpeed(%d)", iname, percent);
    char tbuf[32];
    int nb = snprintf(tbuf, 32, "901,%d,999\n", percent);
    if (nb >= 32) {
      msg(2, "%s: Unexpected truncation in SetSpeed()", iname);
    } else {
      rv = iwrite(tbuf, nb);
    }
    cur_percent = percent;
    if (percent != 0) {
      TO.Set(0, retx_interval_msec);
    } else {
      TO.Clear();
    }
  } else {
    msg(2, "%s: obuf not empty in SetSpeed()", iname);
  }
  return rv;
}

bool Ascend::protocol_input() {
  int16_t ctrl_input, mode, limit1, limit2;
  int16_t HoistV, HoistI, SpeedCmd, Speed, Position;
  int16_t Temp[4];
  
  if (not_str("900,") ||
      not_range_input(ctrl_input, "ctrl_input", 0, 1, 3) ||
      not_range_input(mode, "mode", 0, 1, 4) ||
      not_range_input(HoistV, "HoistV", 1, 0, 1500) ||
      not_range_input(HoistI, "HoistI", 0, 0, 127) ||
      not_range_input(SpeedCmd, "SpeedCmd", 0, -100, 100) ||
      not_range_input(Speed, "Speed", 1, -128, 127) ||
      not_range_input(Position, "Position", 0, -1000, 1000) ||
      not_range_input(Temp[0], "Temp1", 0, -128, 127) ||
      not_range_input(Temp[1], "Temp1", 1, -128, 127) ||
      not_range_input(Temp[2], "Temp1", 2, -128, 127) ||
      not_range_input(Temp[3], "Temp1", 3, -128, 127) ||
      not_range_input(limit1, "limit1", 0, 0, 1) ||
      not_range_input(limit2, "limit2", 0, 0, 1) ||
      not_str("999\n") ) {
    if (cp >= nc) return false;
  } else {
    Ascender.HoistV = HoistV;
    Ascender.Position = Position;
    Ascender.Status =
      (ctrl_input & 3) |
      (((mode-1) & 3) << 2) |
      ((limit1 & 1) << 4) |
      ((limit2 & 1) << 5);
    Ascender.HoistI = HoistI;
    Ascender.SpeedCmd = SpeedCmd;
    Ascender.Speed = Speed;
    Ascender.Temp[0] = Temp[0];
    Ascender.Temp[1] = Temp[1];
    Ascender.Temp[2] = Temp[2];
    Ascender.Temp[3] = Temp[3];
    ++Ascender.Nreports;
    report_ok(0);
  }
  consume(nc);
  return false;
}

bool Ascend::tm_sync() {
  Ascender.Nreports = 0;
  return false;
}

bool Ascend::protocol_timeout() {
  msg(MSG_DEBUG, "%s: Retransmit", iname);
  SetSpeed(cur_percent);
  return false;
}

bool Ascend::not_range_input(int16_t &val, const char *vname,
      int fix, int32_t min, int32_t max) {
  bool rv;
  int16_t val16;
  int32_t val32;
  if (fix > 0) {
    rv = not_fix(fix,val16);
    val32 = val16;
  } else {
    rv = not_int32(val32);
  }
  if (!rv)
    rv = not_str(",");
  if (!rv && (val32 < min || val32 > max)) {
    report_err("%s: %s value (%d) out of range",
      iname, vname, val32);
    val = 0;
  } else {
    val = val32;
  }
  return rv;
}

AscendCmd::AscendCmd(Ascend *Device)
  : Cmd_reader("Cmd", 80, "ascender"),
    Device(Device) {
  flags |= Fl_Timeout;
}

bool AscendCmd::app_input() {
  int32_t speed;
  int32_t dur_msecs;
  bool rv = false;
  switch (buf[0]) {
    case 'W':
      if (not_str("W") ||
          not_int32(speed) ||
          not_str(":") ||
          not_int32(dur_msecs) ||
          not_str("\n")) {
        report_err("%s: Invalid speed command", iname);
        break;
      }
      msg(MSG_DEBUG, "%s: Cmd %d %d", iname, speed, dur_msecs);
      rv = Device->SetSpeed(speed);
      if (speed) {
	TO.Set(0, dur_msecs);
      } else {
	TO.Clear();
      }
      break;
    case 'Q':
      report_ok(nc);
      return true;
    default:
      report_err("%s: Invalid command", iname);
  }
  report_ok(nc);
  return rv;
}

bool AscendCmd::protocol_timeout() {
  msg(MSG_DEBUG, "%s: End of drive", iname);
  TO.Clear();
  return Device->SetSpeed(0);
}

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  msg(0, "Starting");
  Loop ELoop;
  { TM_data_sndr *TM = new
      TM_data_sndr("TM", 0, "Ascender",
          &Ascender, sizeof(Ascender));
    TM->connect();
    ELoop.add_child(TM);
    Ascend *Device = new Ascend("Device");
    ELoop.add_child(Device);
    AscendCmd *Cmd = new AscendCmd(Device);
    Cmd->connect();
    ELoop.add_child(Cmd);
  }
  ELoop.event_loop();
  ELoop.delete_children();
  msg(0, "Terminating");
  return 0;
}
