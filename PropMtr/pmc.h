/** @file pmc.h */
#ifndef PMC_H_INCLUDED
#define PMC_H_INCLUDED

#include "PropMtr.h"
#include "dasio/modbus_rtu.h"

namespace DAS_IO { namespace Modbus {

  class PMC : public RTU {
    public:
      /**
       * Initializes interface and opens the device.
       * @param iname Interface name for messages
       * @param bufsz The input buffer size
       * @param path Path to the device
       */
      inline PMC(const char *iname, int bufsz, const char *path)
        : RTU(iname, bufsz, path);
      void enqueue_poll(modbus_req *req, int gflag_no = 0);
      std::deque<modbus_req *> fast_polls;
      std::deque<modbus_req *>::const_iterator cur_fast_poll;
    protected:
      inline ~PMC() {}
      void update_polls(int flag);
      modbus_req *next_poll();
  };

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
