%INTERFACE <PropMtr>
%INTERFACE <Quit>
%{
  #ifdef SERVER
  #include <stdint.h>
  
  void PMC_state(uint8_t devID, uint8_t state, bool value) {
    if_PropMtr.Turf("W%02X:0F:00:8:%02X\n", devID, value ? state : 0);
  }
  
  void PMC_coil(uint8_t devID, uint16_t addr, bool value) {
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X\n",
      devID, 15, addr, 1, value ? 1 : 0);
  }
  
  void PMC_setpoint(uint8_t devID, uint16_t addr, double setpoint) {
    uint16_t data[2];
    int32_t isp = setpoint;
    data[0] = isp & 0xFFFF;
    data[1] = (isp >> 16) & 0xFFFF;
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X:%04X\n",
      devID, 16, addr, 2, data[0], data[1]);
  }
  #endif
%}

&start
  : &commands Quit * { msg(0, "Shutting down"); }
  : &commands &&Exit
  ;
&&Exit
  : Exit * { /* cgc_forwarding = 0; */ }
  ;
&commands
  :
  : &commands &command
  ;
&command
  : *
  : Log %s (Enter String to Log to Memo) * {}
  ;
 
&command
  : PMC &pmc_drive &pmc_state &pmc_enable * {
      PMC_state($2, $3, $4);
    }
  : PMC &pmc_drive &pmc_en_coil &pmc_enable * {
      PMC_coil($2, $3, $4);
    }
  : PMC &pmc_drive &pmc_dis_coil &pmc_enable * {
      PMC_coil($2, $3, !$4);
    }
  : PMC &pmc_drive Select &pmc_cfg * {
      PMC_coil($2, 32, $4);
    }
  : PMC &pmc_drive Velocity Set %f (Specify RPM) RPM * {
      PMC_setpoint($2, 321, $5 * 65536. / 75.);
    }
  : PMC &pmc_drive Move to %f (Counts) * {
      PMC_setpoint($2, 321, $5);
    }
  ;

&pmc_drive <uint8_t>
  : Left { $0 = 63; }
# : Right { $0 = 2; }
  ;

&pmc_state <uint8_t>
# : Drive Bridge { $0 = 1; }
  : Home Execute { $0 = 0x20; }
# : Stop { $0 = 0x40; }
  ;
&pmc_dis_coil <uint16_t>
  : Drive Bridge { $0 = 0; }
  : External Brake { $0 = 64; }
  ;

&pmc_en_coil <uint16_t>
# : Home Execute { $0 = 5; }
  : Stop { $0 = 6; }
  : Reset Events { $0 = 12; }
  ;

&pmc_enable <bool>
  : Enable { $0 = true; }
  : Disable { $0 = false; }
  ;
  
&pmc_cfg <bool>
  : Velocity Control { $0 = false; }
  : Position Control { $0 = true; }
  ;
