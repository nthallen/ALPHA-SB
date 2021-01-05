#ifndef SPATIALDUAL_H_INCLUDED
#define SPATIALDUAL_H_INCLUDED

typedef struct  __attribute__((__packed__)) {
  uint16_t system_status;
  uint16_t filter_status;
  uint32_t unix_seconds;
  uint32_t microseconds;
  double latitude;
  double longitude;
  double height;
  float velocity_north;
  float velocity_east;
  float velocity_down;
  float body_accel_x;
  float body_accel_y;
  float body_accel_z;
  float g_force;
  float roll; // radians
  float pitch;
  float heading;
  float angular_velocity_x;
  float angular_velocity_y;
  float angular_velocity_z;
  float latitude_std;
  float longitude_std;
  float height_std;
} system_state_t;

extern system_state_t SpatialDual;

#endif
