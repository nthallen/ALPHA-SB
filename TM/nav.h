#ifndef NAV_H_INCLUDED
#define NAV_H_INCLUDED
#include <cmath>
#include <cstdint>

class nav_pid_t {
  public:
    nav_pid_t();
    inline void set_gains(float P, float I, float D) {
      PGain = P;
      IGain = I;
      DGain = D;
    }
    inline void set_course(uint16_t course, uint8_t thrust) {
      if (this->course != course)
        course_rad = (course/100.) * PI/180;
      this->course = course;
      this->thrust = thrust;
    }
    /**
     * @param heading Angle in radians
     */
    void set_rpm_pid(double heading);

    /**
     * @param dTh Newtons differential thrust
     */
    void set_rpm_dth(double dTh);
    
    /**
     * @param thrust in Newtons
     * @return RPM to achieve specified thrust
     */
    inline double thrust2RPM(double thrust) {
      return sqrt(thrust * 2270);
    }
  protected:

    /**
     * Modifies value if necessary to ensure that it is within
     * the range [-abs_limit, abs_limit]
     * @param value input/output
     * @param abs_limit The limit
     */
    void clamp(double &value, double abs_limit);

    /**
     * @param a1 Angle 1 in radians
     * @param a2 Angle 2 in radians
     * @return The difference between Angle 1 and Angle 2 reduced
     * modulo 2PI to the range [-PI,PI]
     */
    double angleDiff(double a1, double a2);
    double prevCourseError;
    double courseErrorIntegral;
    static const double courseErrorIntegralLimit;
    static const double absMaxThrustPerEngine; //< in Newtons
    static const double PI;
    double PGain, IGain, DGain;
    uint16_t course; //< Course angle as Nav_Angle_t degrees
    double course_rad; //< Course angle in radians
    uint8_t thrust; //< thrust as percent of max thrust
};
extern nav_pid_t nav_pid;

/**
 * Called from SpatialDual_conv.tmc
 * @param vn velocity north in m/s
 * @param ve velocity east in m/s
 * @param hd heading in radians
 * @return track (angle of travel) in radians
 */
float nav_track(float vn, float ve, float hd);

/**
 * Called from SpatialDual_conv.tmc
 * @param vn velocity north in m/s
 * @param ve velocity east in m/s
 * @return horizontal speed in m/s
 */
float nav_speed(float vn, float ve);

inline void nav_set_gains(float P, float I, float D) {
  nav_pid.set_gains(P, I, D);
}

inline void nav_set_course(double course, uint8_t thrust) {
  nav_pid.set_course(course, thrust);
}

inline void nav_set_rpm_pid(double heading) {
  nav_pid.set_rpm_pid(heading);
}

inline void nav_set_rpm_dth(double dthrust) {
  nav_pid.set_rpm_dth(dthrust);
}

#endif
