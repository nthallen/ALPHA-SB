/** @file pmc.h */
#ifndef PMC_H_INCLUDED
#define PMC_H_INCLUDED

#include "PropMtr.h"
#include "dasio/modbus_rtu.h"

namespace DAS_IO::Modbus {

  class PMC_dev : public RTU::modbus_device {
    public:
      PMC_dev(const char *dev_name, uint8_t devID, PMC_t *Ctrl);
      ~PMC_dev();
      void enqueue_polls();
      void process_pdu(RTU::modbus_req *req);
    protected:
      PMC_t *Ctrl;
  };

}

#endif
