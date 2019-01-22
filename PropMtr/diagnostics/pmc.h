/** @file pmc.h */
#ifndef PMC_H_INCLUDED
#define PMC_H_INCLUDED

#include "PropMtr.h"
#include "dasio/modbus_rtu.h"

namespace DAS_IO { namespace Modbus {

  class PMC_dev : public RTU::modbus_device {
    public:
      PMC_dev(const char *dev_name, uint8_t devID, PMC_t *Ctrl);
      ~PMC_dev();
      void enqueue_polls();
      static void RH_cfg(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB);
      static void RH_userbit(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB);
      static void RH_digout(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB);
      static void my_RH_uint32(RTU::modbus_req *req, RTU::modbus_device *dev,
          RTU *MB);
    protected:
      PMC_t *Ctrl;
  };

} }

#endif
