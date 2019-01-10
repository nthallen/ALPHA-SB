/** @file pmc.cc */
#include "PropMtr_int.h"
#include "pmc.h"
#include "nl.h"
#include "nl_assert.h"

namespace DAS_IO { namespace Modbus {

  PMC_dev::PMC_dev(const char *dev_name, uint8_t devID, PMC_t *Ctrl) :
    RTU::modbus_device(dev_name, devID), Ctrl(Ctrl) {}

  PMC_dev::~PMC_dev() {}

  void PMC_dev::RH_bits(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB) {
    // This will be used for two coils at address 32 and 64
    // dest will point to a uint16_t word, (status[6]) and the single bits
    // will be mapped in to bits 4 and 5 respectively
    uint8_t temp;
    MB->read_pdu(&temp, 1);
    uint16_t mask = req->address == 32 ? 0x10 : 0x20;
    uint16_t *dest = (uint16_t*)(req->dest);
    if (temp & 1) {
      *dest |= mask;
    } else {
      *dest &= ~mask;
    }
  }
  
  void PMC_dev::my_RH_uint32(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB) {
    RTU::modbus_device::RH_uint32(req, dev, MB);
    // nl_error(0, "Req: %s", req->ascii_escape());
    nl_error(0, "%s", MB->ascii_escape());
  }

  void PMC_dev::enqueue_polls() {
    nl_assert(MB);
    RTU::modbus_req *req;
    
    // Status words
    req = MB->new_modbus_req();
    req->setup(this, 4, 5, 11, (void*)&(Ctrl->Status[0]));
    MB->enqueue_poll(req);
    
    // Configuration selection
    req = MB->new_modbus_req();
    req->setup(this, 1, 32, 1, (void*)&(Ctrl->Status[7]), RH_bits);
    MB->enqueue_poll(req);
    
    // Brake command
    req = MB->new_modbus_req();
    req->setup(this, 1, 64, 1, (void*)&(Ctrl->Status[8]), RH_bits);
    MB->enqueue_poll(req);
    
    // Voltage and current
    req = MB->new_modbus_req();
    req->setup(this, 4, 12, 4, (void*)&(Ctrl->BusVoltage));
    MB->enqueue_poll(req);
    
    // Velocity
    req = MB->new_modbus_req();
    req->setup(this, 4, 251, 4, (void*)&(Ctrl->VelocityMeasured),
      RTU::modbus_device::RH_uint32);
    MB->enqueue_poll(req);
    
    // Position
    req = MB->new_modbus_req();
    req->setup(this, 4, 257, 6, (void*)&(Ctrl->PositionMeasured),
      RTU::modbus_device::RH_uint32);
    MB->enqueue_poll(req);
    
    // SetPoint
    req = MB->new_modbus_req();
    req->setup(this, 3, 321, 2, (void*)&(Ctrl->SetPoint),
      RTU::modbus_device::RH_uint32);
    MB->enqueue_poll(req);
  }

} } // closeout DAS_IO::Modbus namespace

PropMtrCmd::PropMtrCmd(DAS_IO::Modbus::RTU *MB)
    : DAS_IO::Client("Cmd", 40, "cmd", "PropMtr"),
      MB(MB) {
}

PropMtrCmd::~PropMtrCmd() {}

bool PropMtrCmd::app_input() {
  uint16_t devID, func, addr, count, data[2];
  if (cp < nc) {
    if (buf[cp] == 'Q') return true;
    if (not_str("W") ||
        not_hex(devID) || not_str(":") ||
        not_hex(func) || not_str(":") ||
        not_hex(addr) || not_str(":") ||
        not_hex(count)) {
      if (cp < nc)
        consume(nc);
      return false;
    }
    if (count < 1 || count > 2) {
      report_err("%s: Invalid count: %d", iname, count);
      consume(nc);
      return false;
    }
    for (int i = 0; i < count; ++i) {
      if (not_str(":") || not_hex(data[i])) {
        if (cp < nc) consume(nc);
        return false;
      }
    }
    DAS_IO::Modbus::RTU::modbus_device *dev = MB->find_device(devID);
    if (devID > 0xFF || !dev) {
      report_err("%s: Invalid device ID %d", iname, devID);
      consume(nc);
      return false;
    }
    DAS_IO::Modbus::RTU::modbus_req *req = MB->new_modbus_req();
    req->setup(dev, func, addr, count);
    req->setup_data(&data[0]);
    if (count == 1)
      nl_error(0, "%s: Recd %02X:%02X:%04X:%04X:%04X",
        iname, devID, func, addr, count, data[0]);
    else
      nl_error(0, "%s: Recd %02X:%02X:%04X:%04X:%04X:%04X",
        iname, devID, func, addr, count, data[0], data[1]);
    MB->enqueue_command(req);
    report_ok(nc);
  }
  return false;
}
