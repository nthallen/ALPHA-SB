/* SCoPEx Simulation
 * Initial attempt to better separate simulation and visualization
 */
#include <stdio.h>
#include <math.h>
#include <unistd.h>
#include "SCoPEx.h"
#include "ode/ode.h"
#include "ode/mass.h"
#include "nl.h"
#include "model_atmos.h"
#include "dualsim.h"
#include "oui.h"

SCoPEx Model;

SCoPEx::SCoPEx() {
  started = false;
  Pressure = 50; // hPa Derived using model_atmos
  Temperature = 212; // K Derived using model_atmos
  HeliumTemperatureOffset = 8;
  // R = 8.314; // Pa m^3 mol-1 K-1
  // air_molar_mass = 28.97; // g/mol
  // rho_air = air_molar_mass*Pressure*0.1/(R*Temperature); // Kg/m^3
  // dRinv = (1/R_He - 1/R_air); // kg K/J
  balloonCd = 0.4;
  balloonMass = 94.4; // kg
  balloonRadius = 0; // Derived
  balloonMaxVolume = 8839.1; // m^3 (from spreadsheet)
  // formulas from Palumbo dissertation
  balloonMaxRadius = 1.383 * pow(balloonMaxVolume, 1./3) / 2;
  balloonMaxHeight = 0.748 * 2 * balloonMaxRadius; // m
  ductCdischarge = 0.75; // duct discharge coefficient: between 0.5 and 1
  ductArea = 0.073; // duct area m^2 (1ft diameter)
  ductHeightRatio = 0.47;
  ductDischargeRate = 0;
  HeliumMass = 150; // kg
  initialAltitude = 0; // m
  // balloonAltitude = 0.0; // m
  // balloonArea = pi * balloonRadius * balloonRadius; // m^2 Derived
  payloadMass = 590.0; // Kg (reduced by tetherMass)
  payloadSize[0] = 1.5; // m
  payloadSize[1] = 1.5;
  payloadSize[2] = 1.5;
  payloadArea = payloadSize[1]*payloadSize[2]; // Y*Z, assumes motion in X direction only

  motorAxisPosition[0] = -payloadSize[0]/2;
  motorAxisPosition[1] = 1.5;
  motorAxisPosition[2] = 0;

  payloadCd = 1.05; // assumes motion in X direction only
  tetherMass = 10; // Kg
  tetherRadius = 0.02;
  tetherLength = 2*balloonMaxHeight;  // length
  // thrust = 4.;
  // thrustIncrement = 0.25;
  direction = 0.; // +X
  gondolaAngleSetpoint = direction; // legacy
  // directionIncrement = 5; // degrees
  // PGain = 0.4/90;
  // IGain = 0;
  // DGain = 0;
  // VPGain = 0;
  // VIGain = 0;
  stepSize = 0.05; // seconds
  gondolaVelocityAngle = 0;
  gondolaAngle = 0;
  gondolaSpeed = 0;
  // prevAngleError = 0;
  ofp = 0;
  tcount = 0;
  opt_logfile = 0;
  opt_navport = 0;
  opt_navbaud = 9600;
  cmdfile = 0;
  nextCmdTime = 0;
  // velocityAngleCorrLimit = 45; //*< degrees
  // velocityAngleIntegral = 0;
  // gondolaAngleIntegral = 0;
  // gondolaAngleIntegralLimit = 0.25;
}

SCoPEx::~SCoPEx() {}

void dMassSetSphericalShell (dMass *m, dReal total_mass, dReal radius) {
#define _I(i,j) I[(i)*4+(j)]
    dMassSetZero (m);
    m->mass = total_mass;
    dReal II = REAL(2.0/3.0) * total_mass * radius*radius;
    m->_I(0,0) = II;
    m->_I(1,1) = II;
    m->_I(2,2) = II;

# ifndef dNODEBUG
    dMassCheck (m);
# endif
}

void SCoPEx::printdR3(const dReal *d) {
  printdRN(d,3);
  // fprintf(ofp, ",%7.3lf,%7.3lf,%7.3lf", (double)d[0], (double)d[1], (double)d[2]);
}

void SCoPEx::printdRN(const dReal *d, int N) {
  int i;
  for (i = 0; i < N; ++i) {
    fprintf(ofp, ",%12.8lf", (double)d[i]);
  }
}

void SCoPEx::dBodyAddDrag(dBodyID ID, dReal Cd, dReal Area) {
  const dReal *V = dBodyGetLinearVel(ID);
  double Vs2 = V[0]*V[0] + V[1]*V[1] + V[2]*V[2];
  if (Vs2 > 1e-6) {
    double Vs = sqrt(Vs2);
    double rho_air = Pressure*100/(R_air*Temperature); // Kg/m^3
    double Fds = 0.5*rho_air*Vs2*Cd*Area;
    dBodyAddForce(ID, -V[0]*Fds/Vs, -V[1]*Fds/Vs, -V[2]*Fds/Vs);
  }
}

dReal SCoPEx::angleDiff(dReal a1, dReal a2) {
  dReal diff = fmod(a1-a2+180,360);
  diff += (diff < 0) ? 180 : -180;
  return diff;
}

void SCoPEx::printTorque(const char *when, const dReal *torque) {
  FILE *save_fp = ofp;
  ofp = stdout;
  printf("%s", when);
  printdR3(torque);
  printf("\n");
  ofp = save_fp;
}

// void SCoPEx::commandStep() {
  // if (opt_commandfile) {
    // double now = tcount * stepSize;
    // while (nextCmdTime <= now) {
      // double dT = cmdfile->eval();
      // if (dT < 0) {
        // run = false;
        // break;
      // }
      // nextCmdTime = now+dT;
    // }
  // }
// }

void SCoPEx::clamp(dReal &value, dReal abs_limit) {
  if (value > abs_limit) {
    value = abs_limit;
  } else if (value < -abs_limit) {
    value = -abs_limit;
  }
}

void SCoPEx::Step() {
  if (tcount > 0)
    dWorldStep(world,stepSize);

  // commandStep();

  const dReal *gondolaTorque = dBodyGetTorque(payloadID);
  
  direction = angleDiff(direction,0); // Normalize
  
  // buoyancy
  calculateBuoyancy();
  // dBodyAddForce(balloonID, 0, 0, -(balloonMass+tetherMass+payloadMass)*GRAVITY);
  // Drag
  dReal balloonArea = pi*balloonRadius*balloonRadius;
  // ### calculate balloonCd based on altitude, velocity
  dBodyAddDrag(balloonID, balloonCd, balloonArea);
  dBodyAddDrag(payloadID, payloadCd, payloadArea);
  // printTorque("After drag", gondolaTorque);
  
  const dReal *newPayloadPos = dBodyGetPosition(payloadID);
  dVector3 boxVelocity;
  gondolaSpeed = 0;
  // Let's just use horizontal velocity at the moment
  for (int i = 0; i < 2; ++i) {
    boxVelocity[i] = (newPayloadPos[i]-prevPayloadPos[i])/stepSize;
    gondolaSpeed += boxVelocity[i]*boxVelocity[i];
    prevPayloadPos[i] = newPayloadPos[i];
  }
  gondolaSpeed = sqrt(gondolaSpeed);

  const dReal *rot = dBodyGetRotation(payloadID);
  gondolaAngle = atan2(rot[1*4+1],rot[0*4+1])*180/pi;

  gondolaVelocityAngle = gondolaSpeed > 0.1 ?
    atan2(boxVelocity[1],boxVelocity[0]) * 180/pi :
    gondolaAngle;
  
#ifdef INTERNAL_CONTROL
  // The outer control loop. This is configured such that
  // PGain and DGain define the inner loop, which controls the gondola
  // angle (and hence the thrust angle). VPGain controls the outer
  // loop, which feeds back on velocity angle. All three gains
  // should be positive.
  dReal velocityAngleError = angleDiff(gondolaVelocityAngle, direction);
  // velocityAngleIntegral += velocityAngleError*VIGain;
  // clamp(velocityAngleIntegral, velocityAngleCorrLimit);
  // dReal velocityAngleCorr = velocityAngleError * VPGain + velocityAngleIntegral;
  // clamp(velocityAngleCorr, velocityAngleCorrLimit);
  
  // gondolaAngleSetpoint = direction - velocityAngleCorr;
  // dReal angleError = angleDiff(gondolaVelocityAngle, gondolaAngleSetpoint);
  gondolaAngleSetpoint = direction;
  dReal angleError = velocityAngleError;
  dReal errorChange = angleError - prevAngleError;
  prevAngleError = angleError;
  gondolaAngleIntegral += angleError * IGain;
  clamp(gondolaAngleIntegral, gondolaAngleIntegralLimit);
  
  dReal dThrust_a = angleError * PGain + errorChange * DGain
          + gondolaAngleIntegral + dThrust;
  
  if (dThrust_a > 1) dThrust_a = 1;
  else if (dThrust_a < -1) dThrust_a = -1;
  thrust_left = thrust * (1+dThrust_a) / 2;
  thrust_right = thrust * (1-dThrust_a) / 2;
#endif
  
  // printf("Thrust: %12.8lf %12.8lf\n", thrust_left, thrust_right);
  dBodyAddRelForceAtRelPos(payloadID, thrust_left, 0, 0,
    motorAxisPosition[0], motorAxisPosition[1], motorAxisPosition[2]);
//    -payloadSize[0]/2, -payloadSize[1]/2, 0); //payloadSize[2]/2);
  dBodyAddRelForceAtRelPos(payloadID, thrust_right, 0, 0,
    motorAxisPosition[0], -motorAxisPosition[1], motorAxisPosition[2]);
//    +payloadSize[0]/2, -payloadSize[1]/2, 0); // payloadSize[2]/2);
  // printTorque("After right thrust", gondolaTorque);

  ++tcount;
}

void SCoPEx::LogBody(dBodyID b) {
  const dReal *vec = dBodyGetPosition(b);
  printdRN(vec, 3);
 vec = dBodyGetLinearVel(b);
  printdRN(vec, 3);
  vec = dBodyGetForce(b);
  printdRN(vec, 3);
  vec = dBodyGetTorque(b);
  printdRN(vec, 3);
  vec = dBodyGetRotation(b);
  printdRN(vec, 12);
}

void SCoPEx::LogJoint(dJointFeedback *j) {
  printdRN(j->f1,3);
  printdRN(j->t1,3);
  printdRN(j->f2,3);
  printdRN(j->t2,3);
}

/* Current log format
function [B, Di] = GetBodyData(D, col)
  Di = col;
  B.T = D(:,1);
  B.Pos = D(:,Di:Di+2); Di = Di + 3;
  B.Vel = D(:,Di:Di+2); Di = Di + 3;
  B.Force = D(:,Di:Di+2); Di = Di + 3;
  B.Torque = D(:,Di:Di+2); Di = Di + 3;
  rotM = D(:,Di:Di+11); Di = Di + 12;

  D = load('scopex.log');
  T = D(:,1);
  Di = 2;
  [gondola,Di] = GetBodyData(D,Di);
  [tether,Di] = GetBodyData(D,Di);
  %[balloon,Di] = GetBodyData(D,Di);
  %[TGjoint,Di] = GetJointData(D,Di);
  [Thrust,Di] = GetSimVar(D,'Thrust',Di,2);
  [Gangles,Di] = GetSimVar(D,'GondolaAngles',Di,5);
 */
void SCoPEx::Log() {
  if (ofp == 0) return;
  fprintf(ofp, "%7.2lf", tcount*stepSize);
  LogBody(payloadID);
  LogBody(tetherID);
  // LogBody(balloonID);
  // LogJoint(&tetherPayloadFB);
  fprintf(ofp,",%12.8lf,%12.8lf", thrust_left, thrust_right);
  fprintf(ofp,",%12.8lf,%12.8lf,%12.8lf,%12.8lf,%12.8lf", gondolaAngle,
          gondolaVelocityAngle, gondolaSpeed, direction, gondolaAngleSetpoint);
  fprintf(ofp,",%12.8lf,%12.8lf,%12.8lf", HeliumMass, balloonVolume,
          HeliumPressureOffset);
  fprintf(ofp, "\n");
}

void SCoPEx::calculateBuoyancy() {
  // First determine gravity
  dReal k_g = -9.81*6371*6371;
  dReal const *balloonPos = dBodyGetPosition(balloonID);
  dReal alt_km = balloonPos[2]/1000;
  dReal den = 6371+alt_km;
  gravity = k_g/(den*den);
  dWorldSetGravity(world,0,0,gravity);
  
  // Balloon Volume
  HeliumMass -= ductDischargeRate * stepSize;
  model_atmos::get_PT(alt_km, Pressure, Temperature);
  dReal rho_he = Pressure*100/
        (R_He * (Temperature+HeliumTemperatureOffset));
  balloonVolume = HeliumMass / rho_he;
  dReal Poffset = 0.; // Pa
  if (balloonVolume > balloonMaxVolume) {
    balloonVolume = balloonMaxVolume;
    rho_he = HeliumMass/balloonVolume;
    Poffset = rho_he * R_He * Temperature - Pressure*100;
  }
  // These values are estimated based on Rodger Farley's
  // initial balloon estimates. These differe from values
  // in his AIAA conference paper.
  balloonRadius = 1.3148 * pow(balloonVolume,1./3) / 2;
  balloonHeight = 0.9462 * 2 * balloonRadius;
  dReal ductHeight = balloonHeight - ductVerticalOffset;
  dReal dP = gravity*(Pressure*100/Temperature)*dRinv*ductHeight
              + Poffset;
  ductDischargeRate = (dP > 0)
    ? ductArea * ductCdischarge * sqrt(2 * dP * rho_he)
    : 0;
  dReal AirMass = balloonVolume * Pressure * 100 / (R_air * Temperature);
  dReal F = gravity * (HeliumMass - AirMass);
  dBodyAddForce(balloonID, 0, 0, F);
  
  dMass m;                 // mass parameter
  dMassSetSphericalShell(&m,balloonMass,balloonRadius);
  dBodySetMass (balloonID,&m);
  HeliumPressureOffset = Poffset/100; // hPa
}

bool SCoPEx::Report(system_status_t *S) {
  if (started) {
    struct timespec ts;
    S->system_status = 0;
    S->filter_status = 0x062F;
    clock_gettime(CLOCK_REALTIME, &ts);
    S->unix_seconds = ts.tv_sec;
    S->microseconds = ts.tv_nsec/1000;

    const dReal *vec = dBodyGetPosition(payloadID);
    S->latitude = initialLatitude + vec[0]/111111.;
    S->longitude = initialLongitude -
      vec[1]/(111111.*cos(S->latitude * 3.14159265358/180));
    S->height = vec[2];

    vec = dBodyGetLinearVel(payloadID);
    S->velocity_north = vec[0];
    S->velocity_east = -vec[1];
    S->velocity_down = -vec[2];

    S->body_accel_x = 0;
    S->body_accel_y = 0;
    S->body_accel_z = 0;
    S->g_force = 0;

    // https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    // Negating heading and pitch to convert from fwd/left/up to fwd/rt/down axes
    vec = dBodyGetQuaternion(payloadID);
    S->heading = -atan2(2*(vec[0]*vec[3]+vec[1]*vec[2]),
                       1-2*(vec[2]*vec[2]+vec[3]*vec[3])); // radians
    S->pitch = -asin(2*(vec[0]*vec[2]-vec[3]*vec[1]));
    S->roll = atan2(2*(vec[0]*vec[1]+vec[2]*vec[3]),
                    1-2*(vec[1]*vec[1]+vec[2]*vec[2]));

    vec = dBodyGetAngularVel(payloadID);
    S->angular_velocity_x =  vec[0]; // radians/sec
    S->angular_velocity_y = -vec[1];
    S->angular_velocity_z = -vec[2];
    S->latitude_std = 0.;
    S->longitude_std = 0.;
    S->height_std = 0.;
  }
  return started;
}

void SCoPEx::Init(int argc, char **argv) {
  int c;
  optind = OPTIND_RESET;
  opterr = 0; /* disable default error message */
  while ((c = getopt(argc, argv, opt_string)) != -1) {
    switch (c) {
      case 'l': opt_logfile = optarg; break;
      case 'p': opt_navport = optarg; break;
      case 'b': opt_navbaud = atoi(optarg); break;
      case '?': msg(MSG_FATAL, "Unrecognized Option -%c", optopt);
    }
  }
  if (opt_logfile) {
    ofp = fopen(opt_logfile, "w");
  }
  
  cmdfile = new commandFile(this);
  cmdfile->addVariable(&thrust_left, "thrustLeft");
  cmdfile->addVariable(&thrust_right, "thrustRight");
  cmdfile->addVariable(&initialAltitude, "initialAltitude");
  cmdfile->addVariable(&ductCdischarge, "ductCdischarge");
  cmdfile->addVariable(&ductArea, "ductArea");
  cmdfile->addVariable(&ductHeightRatio, "ductHeightRatio");
  // cmdfile->addVariable(&dThrust, "dThrust");
  // cmdfile->addVariable(&direction, "Direction");
  // cmdfile->addVariable(&PGain, "PGain");
  // cmdfile->addVariable(&IGain, "IGain");
  // cmdfile->addVariable(&DGain, "DGain");
  // cmdfile->addVariable(&VPGain, "VPGain");
  // cmdfile->addVariable(&VIGain, "VIGain");
  // cmdfile->addVariable(&velocityAngleCorrLimit, "velocityAngleCorrLimit");
  // cmdfile->addVariable(&gondolaAngleIntegralLimit,
                          // "gondolaAngleIntegralLimit");
  
  cmdfile->connect();
  ELoop.add_child(cmdfile);
  
  if (opt_navport) {
    dualsim *navout = new dualsim(opt_navport, opt_navbaud, this);
    ELoop.add_child(navout);
  }
  // commandStep();
}

void SCoPEx::Start() {
  if (started) return;
  started = true;
  dInitODE();              // Initialize ODE
  world = dWorldCreate();  // Create a world

  dMass m;                 // mass parameter
  dMassSetZero (&m);  //set mass parameter to zero

  dReal payloadAltitude = initialAltitude+payloadSize[2]/2;
  dReal tetherAltitude = initialAltitude+payloadSize[2]+tetherLength/2;
  dReal balloonAltitude =
    initialAltitude+payloadSize[2]+tetherLength+balloonMaxRadius;
  
  // sphere
  balloonID = dBodyCreate (world);     //  create a body
  // dMassSetSphericalShell(&m,balloonMass,balloonRadius); // Calculate mass parameter
  // dBodySetMass (balloonID,&m);  // Set mass parameter to the body
  // dBodySetPosition (balloonID,0,1, balloonRadius + tetherLength + 1); // Set a position
  dBodySetPosition (balloonID,0,0, balloonAltitude); // Set a position
  ductVerticalOffset = balloonMaxHeight*(1-ductHeightRatio);

  calculateBuoyancy();

  // Tether
  tetherID = dBodyCreate (world);
  dMassSetCylinderTotal(&m,tetherMass,3,tetherRadius,tetherLength);
  dBodySetMass (tetherID,&m);
  dBodySetPosition (tetherID,0,0,balloonAltitude-balloonRadius-tetherLength/2);
  
  balloonTether = dJointCreateBall(world,0);
  dJointAttach(balloonTether, balloonID, tetherID);
  dJointSetBallAnchor(balloonTether,0,0,balloonAltitude-balloonRadius);
  dJointEnable(balloonTether);

  // payload
  payloadID = dBodyCreate (world);
  dMassSetBoxTotal (&m,payloadMass,payloadSize[0],payloadSize[1],payloadSize[2]);
  dBodySetMass (payloadID,&m);
  dBodySetPosition (payloadID,0,0,payloadAltitude);
  prevPayloadPos[0] = 0;
  prevPayloadPos[1] = 0;
  prevPayloadPos[2] = payloadAltitude;
  // dMatrix3 pRot = {
     // 0, 1, 0, 0,
    // -1, 0, 0, 0,
     // 0, 0, 1, 0 };
  //dBodySetRotation(payloadID, pRot);
  
  tetherPayload = dJointCreateBall(world,0);
  dJointAttach(tetherPayload, tetherID, payloadID);
  dJointSetBallAnchor(tetherPayload,0,0,balloonAltitude-balloonRadius-tetherLength);
  dJointEnable(tetherPayload);
}

void SCoPEx::Loop() {
  msg(0, "Starting");
  ELoop.event_loop();
  ELoop.delete_children();
  ELoop.clear_delete_queue(true);
  msg(0, "Terminating");
}

void SCoPEx::Close() {
  if (opt_logfile) {
    fclose(ofp);
    ofp = 0;
  }
  dWorldDestroy (world); // destroy the world
  dCloseODE();           // close ODE
}

void scopex_sim_init_options(int argc, char **argv) {
  Model.Init(argc, argv);
}

int main (int argc, char **argv) {
  oui_init_options(argc, argv);
  Model.Loop();
  Model.Close();
  return 0;
}