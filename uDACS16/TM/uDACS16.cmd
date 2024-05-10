&^command
  : ICM Select &icm_mode * {
      uDACS->write_ack(0x130, 40+$3);
      uDACS->write_ack(0x230, 40+$3);
    }
  : ICM Select Full Scale &icm_fs * {
      uDACS->write_ack(0x130, 50+$5);
      uDACS->write_ack(0x230, 50+$5);
    }
  ;

&icm_mode <int>
  : Idle Mode { $0 = 0; }
  : Slow Mode { $0 = 1; }
  : Fast Mode { $0 = 2; }
  : MaxG Mode { $0 = 3; }
  ;

&icm_fs <int>
  : 2g { $0 = 0; }
  : 4g { $0 = 1; }
  : 8g { $0 = 2; }
  : 16g { $0 = 3; }
  ;
