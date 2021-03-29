#ifndef RFDIO_INT_H_INCLUDED
#define RFDIO_INT_H_INCLUDED
#include "dasio/serial.h"
#include "dasio/client.h"
#include "dasio/cmd_reader.h"
#include "serio_pkt.h"

using namespace DAS_IO;

class serio_if : public Client {
  public:
    serio_if();
    /**
     * @param pkt Pointer to the complete serio packet
     * @param length The number of bytes in the packet
     * @return true if the packet could not be sent
     */
    bool forward_packet(const char *pkt, int length);
  private:
    int packets_forwarded;
};

class RFD_interface : public Serial {
  public:
    RFD_interface(const char *name, serio_if *serio);
    // ~RFD_interface();
    void tx_cmd(struct iovec *io, int n_iov);
    static const int ibufsize = 4096;
    static const char *RFD_port;
    static int RFD_baud_rate;
  protected:
    /**
     * Opens the serial port and sets up for operation.
     * On failure, sets a timeout for retry.
     */
    void connect();
    /**
     * Disables read and write flags and sets up to
     * receive a timeout in 5 seconds.
     */
    void queue_retry();
    /**
     * This is a standard DAS_IO::Interface parsing
     * method. The code is copied in both serin and RFDio.
     * @return true unless a properly formatted serio_pkt_hdr
     * is located in the input buffer.
     */
    bool not_serio_pkt_hdr();
    bool protocol_input();
    bool protocol_timeout();
    bool protocol_except();
    bool read_error(int my_errno);
    bool process_eof();
    const char *ascii_escape();
    bool write_blocked;
    bool connect_waiting;
    int recd_pkts_dropped;
    serio_if *serio;
};

class RFD_cmd : public Cmd_reader {
  public:
    RFD_cmd(RFD_interface *RFD);
    bool app_input();
  protected:
    RFD_interface *RFD;
    bool dropping_tx_cmds;
    int n_tx_cmds_dropped;
    int total_tx_cmds_dropped;
};

#endif
