#include "nav.h"

nav_pid_t nav_pid

nav_pid_t::nav_pid_t()
    : prevCourseError(0),
      courseErrorIntegral(0),
      PGain(0), IGain(0), DGain(0)
      {}

void nav_pid_t::set_gains(float P, float I, float D) {
  PGain = P;
  IGain = I;
  DGain = D;
}
  
void clamp(double &value, double abs_limit) {
  if (value > abs_limit) {
    value = abs_limit;
  } else if (value < -abs_limit) {
    value = -abs_limit;
  }
}

double angleDiff(double a1, double a2) {
  dReal diff = fmod(a1-a2+180,360);
  diff += (diff < 0) ? 180 : -180;
  return diff;
}

float nav_track(float vn, float ve) {
  return atan2f(vn, ve);
}

SD_vel_t velocity_forward; Invalidate velocity_forward;
{ velocity_forward = nav_speed(velocity_north, velocity_east);
  Validate velocity_forward; }
