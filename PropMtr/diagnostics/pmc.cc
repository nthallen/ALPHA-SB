/** @file pmc.cc */
#include "PropMtr.h"
#include "pmc.h"
#include "nl.h"
#include "nl_assert.h"

namespace DAS_IO::Modbus {

  PMC_dev::PMC_dev(const char *dev_name, uint8_t devID, PMC_t *Ctrl) :
    RTU::modbus_device(dev_name, devID), Ctrl(Ctrl) {}

  PMC_dev::~PMC_dev() {}

  void PMC_dev::enqueue_polls() {
    nl_assert(MB);
    RTU::modbus_req *req;
    
    // Status words
    req = MB->new_modbus_req();
    req->setup(this, 4, 5, 7, (void*)&(Ctrl->Status[0]),
      RTU::modbus_req::Rep_uint16);
    MB->enqueue_poll(req);
    
    // Configuration selection
    req = MB->new_modbus_req();
    req->setup(this, 1, 32, 1, (void*)&(Ctrl->Status[7]));
    MB->enqueue_poll(req);
    
    // Brake command
    req = MB->new_modbus_req();
    req->setup(this, 1, 64, 1, (void*)&(Ctrl->Status[8]));
    MB->enqueue_poll(req);
    
    // Voltage and current
    req = MB->new_modbus_req();
    req->setup(this, 4, 12, 4, (void*)&(Ctrl->BusVoltage),
      RTU::modbus_req::Rep_uint16);
    MB->enqueue_poll(req);
    
    // Velocity
    req = MB->new_modbus_req();
    req->setup(this, 4, 251, 4, (void*)&(Ctrl->VelocityMeasured),
      RTU::modbus_req::Rep_uint32);
    MB->enqueue_poll(req);
    
    // Position
    req = MB->new_modbus_req();
    req->setup(this, 4, 257, 6, (void*)&(Ctrl->PositionMeasured),
      RTU::modbus_req::Rep_uint32);
    MB->enqueue_poll(req);
    
    // SetPoint
    req = MB->new_modbus_req();
    req->setup(this, 3, 321, 2, (void*)&(Ctrl->SetPoint),
      RTU::modbus_req::Rep_uint32);
    MB->enqueue_poll(req);
  }

  // void PMC_dev::process_pdu(RTU::modbus_req *req) {
    // switch (req->function_code) {
      // case 1:
        // switch (req->address) {
          // case 0:
            // MB->read_pdu((uint8_t *)&Ctrl->CtrlWord0, 0, 2);
            // return;
          // case 16:
            // MB->read_pdu((uint8_t *)&Ctrl->CtrlWord1, 0, 2);
            // return;
          // default:
            // break;
        // }
        // break;
      // case 8:
        // switch (req->address) {
          // case 14: // Server Message Count
            // MB->read_pdu(&(Ctrl->msg_count), 0, 1);
            // return;
          // default:
            // break;
        // }
        // break;
      // default:
        // break;
    // }
    // nl_error(4, "%s/%s: Invalid function/subfunction code %d/%d in process_pdu",
      // get_iname(), get_dev_name(), req->function_code, req->address);
    // // Process requests
  // }

}
