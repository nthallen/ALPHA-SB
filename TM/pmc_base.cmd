%INTERFACE <PropMtr>
%{
  #if defined(SERVER) && !defined(TRANSMITTING)
  #include <stdint.h>
  
  void PMC_state(uint8_t devID, uint8_t state, bool value) {
    if_PropMtr.Turf("W%02X:0F:00:8:%02X\n", devID, value ? state : 0);
  }
  
  void PMC_coil(uint8_t devID, uint16_t addr, bool value) {
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X\n",
      devID, 15, addr, 1, value ? 1 : 0);
  }
  
  void PMC_holdreg_16(uint8_t devID, uint16_t addr, uint16_t value) {
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X\n",
      devID, 6, addr, 1, value);
  }
  
  void PMC_holdreg_32(uint8_t devID, uint16_t addr, uint32_t value) {
    uint16_t data[2];
    data[0] = value & 0xFFFF;
    data[1] = (value>>16) & 0xFFFF;
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X:%04X\n",
      devID, 16, addr, 2, data[0], data[1]);
  }
  
  void PMC_setpoint(uint8_t devID, uint16_t addr, double setpoint) {
    uint16_t data[2];
    int32_t isp = setpoint * (devID&1 ? 1 : -1);
    data[0] = isp & 0xFFFF;
    data[1] = (isp >> 16) & 0xFFFF;
    if_PropMtr.Turf("W%02X:%02X:%04X:%04X:%04X:%04X\n",
      devID, 16, addr, 2, data[0], data[1]);
  }
  #endif
%}

&^command
  : PMC &pmc_drive &pmc_state &pmc_enable * {
      PMC_state($2, $3, $4);
    }
  : PMC &pmc_drive &pmc_en_coil &pmc_enable * {
      PMC_coil($2, $3, $4);
    }
  : PMC &pmc_drive &pmc_dis_coil &pmc_enable * {
      PMC_coil($2, $3, !$4);
    }
  : PMC &pmc_drive &pmc_brake_coil &pmc_brake_action * {
      PMC_coil($2, $3, $4);
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
  : PMC &pmc_drive Set Velocity Loop Proportional Gain %f * {
      int32_t value;
      double dvalue;
      /* dvalue = gain($8) * (2^16 * Vvel * Rppv)/(2*Cpk)
           Vvel = Switching Freq/2 = 10000
           Rppv = 1??
           Cpk = 25A
       */
      dvalue = $8 * (32768. * 10000. * 1) / (2*25.);
      if (dvalue >= 32768 * 16384)
        dvalue = 32768*16384-1;
      value = (int32_t)dvalue;
      PMC_holdreg_32($2, 251, (uint32_t)value);
    }
  : PMC &pmc_drive Set Velocity Loop Integral Gain %f * {
      int32_t value;
      double dvalue;
      /* dvalue = gain($8) * (2^32 * Rppv)/(2*Cpk)
           Rppv = 1??
           Cpk = 25A
       */
      dvalue = $8 < 0 ? 0 : $8 * (32768. * 32768. * 1) / (2*25.);
      if (dvalue >= 32768 * 16384)
        dvalue = 32768*16384-1;
      value = (int32_t)dvalue;
      PMC_holdreg_32($2, 251, (uint32_t)value);
    }
  : PMC &pmc_drive Set Velocity Loop Derivative Gain %f * {
      int32_t value;
      double dvalue;
      /* dvalue = gain($8) * (2^16 * (Vvel^2) * Rppv)/(2*Cpk)
           Vvel = Switching Freq/2 = 10000
           Rppv = 1??
           Cpk = 25A
       */
      dvalue = $8 < 0 ? 0 : $8 * (32768. * 1e8 * 1) / (2*25.);
      if (dvalue >= 32768 * 16384)
        dvalue = 32768*16384-1;
      value = (int32_t)dvalue;
      PMC_holdreg_32($2, 253, (uint32_t)value);
    }
  : PMC &pmc_drive Set Torque Current Loop Proportional Gain %f * {
      int16_t value;
      double dvalue;
      /* dvalue = gain($9) * 2^9 */
      dvalue = $9 >= 0 ? $9 * 512 : 0;
      value = (int16_t)dvalue;
      PMC_holdreg_16($2, 46, (uint16_t)value);
    }
  : PMC &pmc_drive Set Torque Current Loop Integral Gain %f * {
      int16_t value;
      double dvalue;
      /* dvalue = gain($9) * 2^9 */
      dvalue = $9 >= 0 ? $9 * 512 : 0;
      value = (int16_t)dvalue;
      PMC_holdreg_16($2, 47, (uint16_t)value);
    }
  ;

&pmc_state <uint8_t>
# : Drive Bridge { $0 = 1; }
  : Home Execute { $0 = 0x20; }
# : Stop { $0 = 0x40; }
  ;

&pmc_dis_coil <uint16_t>
  : Bridge { $0 = 0; }
  ;

&pmc_brake_coil <uint16_t>
  : Brake { $0 = 64; }
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
&pmc_brake_action <bool>
  : Release { $0 = true; }
  : Apply { $0 = false; }
  ;
&pmc_cfg <bool>
  : Velocity Control { $0 = false; }
  : Position Control { $0 = true; }
  ;
