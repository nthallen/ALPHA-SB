#ifndef ICM20948_DRV_H_INCLUDED
#define ICM20948_DRV_H_INCLUDED
#include <stdio.h>
#include "dasio/cmd_reader.h"
#include "dasio/tm_data_sndr.h"
#include "subbuspp.h"
#include "ICM20948.h"
#include "mlf.h"

using namespace DAS_IO;

class ICM_dev : public Interface {
  public:
    ICM_dev();
    /**
     * @param mode: 0: idle, 1: slow updates, 2: fast updates
     */
    void set_mode(uint8_t mode);
    /**
     * @param fs: full scale value 0-3
     * Full scale range for acceleration is 2^(fs+1) g
     */
    void set_fs(uint8_t fs);
    /**
     * Called by ICM_cmd_t when a quit command is received.
     */
    void Quit();
    void event_loop();
    static const char *subbusd_service;
    static const int NS = N_ICM20948_SENSORS;
    static const int samples_per_report = 512;
    static const int max_skip = 300; // arbitrary
    static const int max_mread = 497; // 497;
    static const int udata_size = (samples_per_report+max_skip)*3+2;
    static const char *mlf_config;
    static const int records_per_file = 5;
  protected:
    void prep_multiread();
    void read_sensors(int i);
    void read_modes(int i);
    subbuspp *SB;
    mlf_def_t *mlf;
    FILE *ofp;
    int records_in_file;
    struct {
      uint16_t udata[udata_size];
      char rm_fifo_fmt[32];
      uint16_t cur_skip;
      uint16_t nw;
    } dev[NS];
    subbus_mread_req *rm_idle[NS];
    subbus_mread_req *rm_fifo[NS];
    bool quit_requested;
    uint8_t req_mode; ///< Requested mode from cmd
    uint8_t req_fs; ///< Requested fs from cmd
    uint8_t req_modefs; ///< Requested modefs
    int Fsample;
    uint8_t cmd_modefs[NS]; ///< Commanded modefs
    uint8_t rep_modefs[NS]; ///< Reported modefs
    static const uint16_t uDACS_cmd_addr = 0x30;
    static const uint16_t uDACS_mode_cmd_offset = 40;
    static const uint16_t uDACS_fs_cmd_offset = 50;
    inline uint8_t mask_mode(uint8_t modefs) { return (modefs&7); }
    inline uint8_t mask_fs(uint8_t modefs) { return (modefs>>3); }
    inline uint8_t mask_modefs(uint8_t mode, uint8_t fs) {
      return (mode | (fs<<3));
    }
    static uint16_t base_addr[NS];
};

class ICM_cmd_t : public Cmd_reader {
  public:
    ICM_cmd_t(ICM_dev *ICM);
  protected:
    // ~ICM_cmd_t();
    bool app_input();
    ICM_dev *ICM;
};

class ICM_TM_t : public TM_data_sndr {
  public:
    ICM_TM_t();
    bool app_input();
  protected:
    // ~ICM_TM_t();
};

#endif
