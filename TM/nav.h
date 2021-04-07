#ifndef NAV_H_INCLUDED
#define NAV_H_INCLUDED
#include <math.h>

class nav_pid_t {
  public:
    nav_pid_t();
    set_gains(float P, float I, float D);
  protected:
    double prevCourseError;
    double courseErrorIntegral;
    static const double courseErrorIntegralLimit = 100.;
    float PGain, IGain, DGain;
};
extern nav_pid_t nav_pid;

inline void nav_set_gains(float P, float I, float D) {
  nav_pid.set_gains(P, I, D);
}

/**
 * Modifies value if necessary to ensure that it is within
 * the range [-abs_limit, abs_limit]
 * @param value input/output
 * @param abs_limit The limit
 */
void clamp(double &value, double abs_limit);

/**
 * @param a1 Angle 1 in degrees
 * @param a2 Angle 2 in degrees
 * @return The difference between Angle 1 and Angle 2 reduced
 * modulo 360 to the range [-180,180]
 */
double angleDiff(double a1, double a2);

/**
 * @param vn velocity north in m/s
 * @param ve velocity east in m/s
 * @param hd heading in radians
 * @return track (angle of travel) in radians
 */
float nav_track(float vn, float ve, float hd);

/**
 * @param vn velocity north in m/s
 * @param ve velocity east in m/s
 * @return horizontal speed in m/s
 */
float nav_speed(float vn, float ve);

#endif
