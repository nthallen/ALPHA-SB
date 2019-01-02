/** @file pmc.cc */
#include "pmc.h"

namespace DAS_IO::Modbus {

  PMC_dev::PMC_dev(const char *dev_name, uint8_t devID) :
    RTU::modbus_device(dev_name, devID) {}

  PMC_dev::~PMC_dev() {}

  void PMC_dev::enqueue_polls() {
    
  }

  void PMC_dev::process_pdu(RTU::modbus_req *req, uint16_t address) {
    
  }

}
