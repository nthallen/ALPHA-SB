/** @file pmc.cc */
#include "PropMtr.h"
#include "pmc.h"
#include "nl.h"
#include "nl_assert.h"

namespace DAS_IO::Modbus {

  PMC_dev::PMC_dev(const char *dev_name, uint8_t devID, PMC_t *Ctrl) :
    RTU::modbus_device(dev_name, devID), Ctrl(Ctrl) {}

  PMC_dev::~PMC_dev() {}
  
  void PMC_dev::my_RH_uint16(RTU::modbus_req *req) {
    RH_uint16(req);
    nl_error(0, "%s", MB->ascii_escape());
  }

  void PMC_dev::enqueue_polls() {
    nl_assert(MB);
    RTU::modbus_req *req;
    
    // Status words
    req = MB->new_modbus_req();
    req->setup(this, 4, 5, 11, (void*)&(Ctrl->Status[0]), my_RH_uint16);
    MB->enqueue_poll(req);
    
    // ### Return to these and write a custom handler
    // // Configuration selection
    // req = MB->new_modbus_req();
    // req->setup(this, 1, 32, 1, (void*)&(Ctrl->Status[7]));
    // MB->enqueue_poll(req);
    
    // // Brake command
    // req = MB->new_modbus_req();
    // req->setup(this, 1, 64, 1, (void*)&(Ctrl->Status[8]));
    // MB->enqueue_poll(req);
    
    // Voltage and current
    req = MB->new_modbus_req();
    req->setup(this, 4, 12, 4, (void*)&(Ctrl->BusVoltage));
    MB->enqueue_poll(req);
    
    // Velocity
    req = MB->new_modbus_req();
    req->setup(this, 4, 251, 4, (void*)&(Ctrl->VelocityMeasured));
    MB->enqueue_poll(req);
    
    // Position
    req = MB->new_modbus_req();
    req->setup(this, 4, 257, 6, (void*)&(Ctrl->PositionMeasured));
    MB->enqueue_poll(req);
    
    // SetPoint
    req = MB->new_modbus_req();
    req->setup(this, 3, 321, 2, (void*)&(Ctrl->SetPoint));
    MB->enqueue_poll(req);
  }

}
