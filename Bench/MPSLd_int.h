/** @file MPSLd_int.h
 * Magna-Power SL Series Bench Power Supply Driver Class Definitions
 */
#ifndef MPSLD_INT_H_INCLUDED
#define MPSLD_INT_H_INCLUDED

#include "dasio/client.h"
#include "dasio/serial.h"
#include "dasio/cmd_reader.h"
#include "rqueue.h"

class MPSL_device : public DAS_IO::Socket {
  public:
    MPSL_device();
    // ~MPSL_device();
    enum CB_ID { CB_NONE, CB_VOLT, CB_CURR, CB_MVOLT, CB_MCURR,
                 CB_OUTP, CB_SETPT, CB_STATUS, CB_SYSERR,
                 CB_CMD, CB_MAX };
    enum CONV_ID { CID_NONE, CID_NR1, CID_NR2, CID_SYSERR, CID_MAX };
    void enqueue_polls();
    bool process_requests();
    DAS_IO::rqueue RQ;
  protected:
    bool protocol_input();
    bool protocol_timeout();
    bool protocol_gflag(int flag);
    bool connected();

    typedef struct {
      int timeout_msec;
      CONV_ID conv;
      bool has_response;
    } reqdef_t[CB_MAX];
    static reqdef_t reqdef;
    static const uint16_t OUTP_MASK = 1<<13;
    static const uint16_t SETPT_MASK = 1<<14;
    static const uint16_t STATUS_MASK = 0x1FFF;
};

class MPSLdCmd : public DAS_IO::Cmd_reader {
  public:
    MPSLdCmd(MPSL_device *MPSL_dev);
    // ~MPSLdCmd();
    bool app_input();
  protected:
    MPSL_device *MPSL_dev;
};

#endif
