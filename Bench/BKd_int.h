/** @file BKd_int.h
 * BK Precision 1687B Bench Power Supply Driver Class Definitions
 */
#ifndef BKD_INT_H_INCLUDED
#define BKD_INT_H_INCLUDED
#include "dasio/client.h"
#include "dasio/serial.h"
#include "dasio/cmd_reader.h"
#include "rqueue.h"

class BK_device : public DAS_IO::Serial {
  public:
    BK_device();
    // ~BK_device();
    enum CB_ID { CB_NONE, CB_GETS, CB_GETD, CB_CMD };
    void enqueue_polls();
    bool process_requests();
    DAS_IO::rqueue RQ;
  protected:
    bool protocol_input();
    bool protocol_timeout();
    bool protocol_gflag(int flag);
};

class BKdCmd : public DAS_IO::Cmd_reader {
  public:
    BKdCmd(BK_device *BK_dev);
    // ~BKdCmd();
    bool app_input();
  protected:
    BK_device *BK_dev;
};

extern const char *BKd_port;

#endif
