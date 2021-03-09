#ifndef SCOPEX_H_INCLUDED
#define SCOPEX_H_INCLUDED
#include "dasio/loop.h"
#include "ode/ode.h"
#include "commandfile.h"
#include "SpatialDual.h"

class SCoPEx {
  public:
    SCoPEx();
    ~SCoPEx();
    void Init(int argc, char **argv);
    void Start();
    void Loop();
    void Step();
    void Log();
    void Report(system_status_t *status);
    void Close();
    DAS_IO::Loop ELoop;
    static void graphicsStart();
    static void graphicsCommand(int c);
  private:
    void clamp(dReal &value, dReal abs_limit);
    void calculateBuoyancy();
    void LogBody(dBodyID b);
    void LogJoint(dJointFeedback *j);
    void printdR3(const dReal *d);
    void printdRN(const dReal *d, int N);
    void printTorque(const char *when, const dReal *torque);
    void dBodyAddDrag(dBodyID ID, dReal Cd, dReal Area);
    dReal angleDiff(dReal a1, dReal a2);
    int tcount;
    double nextCmdTime;
    double Pressure; // hPa
    double Temperature; // K
    double HeliumTemperatureOffset; // K
    double HeliumPressureOffset; // hPa
    dBodyID balloonID;
    dReal balloonCd; // function of balloon size, altitude
    dReal balloonMass; // Kg
    dReal balloonRadius; // m: varies with altitude, used for vertical drag
    dReal balloonHeight; // m: calculated from volume
    dReal balloonVolume; // m^3: calculated
    dReal balloonMaxVolume; // m^3: from spreadsheet
    dReal balloonMaxRadius; // m: calculated from balloonMaxVolume
    dReal balloonMaxHeight; // m: used to determine tether length
    dReal ductVerticalOffset; // m from top of balloon
    dReal ductCdischarge = 0.75; // duct discharge coefficient: between 0.5 and 1
    dReal ductArea = 0.073; // duct area m^2 (1ft diameter)
    dReal ductHeightRatio = 0.47;
    dReal ductDischargeRate; // kg/sec
    dReal HeliumMass; //
    dReal initialAltitude; // m
    double initialLatitude; // deg
    double initialLongitude; // deg
    // dReal balloonArea; // m^2
    dReal gondolaAngle;
    dReal gondolaVelocityAngle;
    dReal gondolaSpeed;
    dReal thrust_left;
    dReal thrust_right;
    
    commandFile *cmdfile;
    const char *opt_logfile;
    const char *opt_navport;
    int opt_navbaud;
    bool run;
    bool started;

    dWorldID world;  // a dynamic world
    FILE *ofp;

    dBodyID payloadID;
    dReal payloadMass; // Kg
    dReal payloadSize[3]; // m
    dReal motorAxisPosition[3]; // m [forward, right/left, up] from COM
    dReal payloadArea; // Y*Z, assumes motion in X direction only
    dReal payloadCd; // assumes motion in X direction only
    
    // These are variable for the direction control
    // direction, which is commanded, specifies the desired velocity direction
    // The setpoint for gondola angle control
    dReal gondolaAngleSetpoint;
    dReal gondolaAngleIntegral;
    dReal gondolaAngleIntegralLimit;
    dReal velocityAngleCorrLimit;
    dReal velocityAngleIntegral;
    dReal prevAngleError;
    dVector3 prevPayloadPos;

    dBodyID tetherID;
    dReal tetherMass; // Kg
    dReal tetherRadius;
    dReal tetherLength;  // length

    dJointID balloonTether;
    dJointID tetherPayload;
    dJointFeedback tetherPayloadFB;
    
    dReal thrust;
    dReal dThrust;
    dReal thrustIncrement;
    dReal direction; // +Y [-180, 180]
    dReal directionIncrement; // degrees
    dReal PGain;
    dReal DGain;
    dReal IGain;
    dReal VPGain;
    dReal VIGain;
    dReal stepSize; // time step in seconds
    dReal gravity;
    static constexpr dReal R_He = 2077; // J/(kg K) specific gas constant for Helium
    static constexpr dReal R_air = 287.058; // J/(kg K) specific gas constant for dry  air
    static constexpr dReal dRinv = (1/R_He - 1/R_air); // kg K/J
    static constexpr dReal pi = 3.14159265358979;
};

void scopex_sim_init_options(int argc, char **argv);

#endif
