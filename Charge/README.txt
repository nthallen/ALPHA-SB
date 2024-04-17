ALPHA-SB Charging Station

Components:
  Magna-Power SL Series Bench Power Supply (MPSL)
  BK Precision 1687B Bench Power (PK)
  Raspberry Pi computer with USB/Ethernet HAT
  Ethernet Switch
  CANable USB/CAN Adapter
  ALPHA-SB Battery System

The Charging Station is currently powered via a single
3-phase connector. The MPSL uses two 208 phases, and
the 3rd phase is used to supply 110 to a plug strip to
power the BK and the Raspberry Pi.

The MPSL connects to the Pi via a private Ethernet
network (10.3.3.0/24). The MPSL is configured for
address 10.3.3.2/24 and the Pi's eth1 interface (on
the HAT) is configured for 10.3.3.1/24

The BK connects to the Pi via a USB cable, and should
appear as /dev/ttyUSB0 on the Pi.

The Pi's eth0 interface (on the main board) is configured
as a fixed IP corresponding to spi2.arp.harvard.edu 10.245.83.84.

CAN: The system should be able to work with either an SLCAN
device (CANable or maybe LAWICEL) or a CANtact Pro. The
configuration needs to be set at the top of the interact
script.
