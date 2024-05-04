# B3MB_map.cmd
# Updated as per Under Link 20220813 Rev 2:
# 28V1(11)  L1(8)     is Port Engine 28V
# 100V1(6->1) L3(12)   is Port Engine 100V
# 28V1(2->11)  L4(14) is Data System 28V
# 28V1(2->11)  L3(12) is Starboard Engine 28V
# 100V4(->4) L3(12) is Starboard Engine 100V
# 100V1(6->1) L4(10->14) is Ascender N1
# 100V2(7->2) L2(10)     is Ascender N2 w/ Precharge sequence
# 100V3(8->3) L2(10)     is Ascender N3 w/ Precharge sequence
# 100V4(3->4) L4(10->14) is Ascender N4

# Power to the ascender requires careful sequencing
#   1: Power up one of the precharge sequence channels (100V2 Load 2)
#   2: Verify that secondary loads are all seeing BusV (100V1 Load 4, 100V3 Load2, 100V4 Load 4)
#   3: Power up the secondary loads
# In flight configuration, 100V3 Load 2 is a backup precharge circuit, so additional logic
# can be added.
%{
  #define CAN_ID_28V1 11
  #define CAN_ID_28V2 12
  #define CAN_ID_28V3 13
  #define CAN_ID_100V1 1
  #define CAN_ID_100V2 2
  #define CAN_ID_100V3 3
  #define CAN_ID_100V4 4
  #define CAN_ID_100V5 5
  #define CAN_ID_100V6 6
  #define CAN_ID_100V7 7
  #define CAN_ID_100V8 8
%}

&^command
  : Power Port Engine 28V &B3MB_On_Off * { B3MB_command(CAN_ID_28V1,B3MB_LOAD_1_CMD,$5); }
  : Power Port Engine 100V &B3MB_On_Off * { B3MB_command(CAN_ID_100V1,B3MB_LOAD_3_CMD,$5); }
  : Power Data System 28V &B3MB_On_Off * { B3MB_command(CAN_ID_28V1,B3MB_LOAD_4_CMD,$5); }
  : Power Starboard Engine 28V &B3MB_On_Off * { B3MB_command(CAN_ID_28V1,B3MB_LOAD_3_CMD,$5); }
  : Power Starboard Engine 100V &B3MB_On_Off * { B3MB_command(CAN_ID_100V4,B3MB_LOAD_3_CMD,$5); }
  : Power USB Hub &B3MB_On_Off * { B3MB_command(CAN_ID_28V3,B3MB_LOAD_2_CMD,$4); }
  : Power HALSA &B3MB_On_Off * { B3MB_command(CAN_ID_28V3,B3MB_LOAD_3_CMD,$3); }
  : Power POPS &B3MB_On_Off * { B3MB_command(CAN_ID_28V3,B3MB_LOAD_4_CMD,$3); }
# : Power Ascender Secondary N1 &B3MB_On_Off * { B3MB_command(CAN_ID_100V1,B3MB_LOAD_4_CMD,$5); }
# : Power Ascender Precharge N2 &B3MB_On_Off * { B3MB_command(CAN_ID_100V2,B3MB_LOAD_2_CMD,$5); }
# : Power Ascender Precharge N3 &B3MB_On_Off * { B3MB_command(CAN_ID_100V3,B3MB_LOAD_2_CMD,$5); }
# : Power Ascender Secondary N4 &B3MB_On_Off * { B3MB_command(CAN_ID_100V4,B3MB_LOAD_4_CMD,$5); }
# : Power Ascender All Off * {
#     B3MB_command(CAN_ID_100V1,B3MB_LOAD_4_CMD,0);
#     B3MB_command(CAN_ID_100V2,B3MB_LOAD_2_CMD,0);
#     B3MB_command(CAN_ID_100V3,B3MB_LOAD_2_CMD,0);
#     B3MB_command(CAN_ID_100V4,B3MB_LOAD_4_CMD,0);
#   }
  ;
