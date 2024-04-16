# ALPHA-SB TM

## Configuration
This section describes a failed strategy: more than one .spec file
in the TM directory.

For this experiment, we are experimenting with actively supporting
two different telemetry frames within the same source directory.
There are two different .spec files, alpha-sb.spec and alpha-sbsim.spec.
With more than one .spec file, appgen must be invoked with an explicit
argument:

```$ appgen alpha-sb.spec```

alpha-sb.spec is the main instrument definition, including all
peripheral devices operating at the anticipated flight data rate.
alpha-sbsim.spec eliminates the B3MB data from the frame and operates
the PropMtr and SpatialDual data at a higher rate to improve the
precision of the alpha-sbsim kinematic model.

It is possible to run simulations using the full instrument definition
as well. As currently configured, the simulation startup (runfile.sim)
does not attempt to run real device drivers (SpatialDual, PropMtr,
B3MB), although it will run comms drivers if configured to do so.

Note: There is a problem here with swsbase. The output files are the
same in each .spec file (SWData.h, etc.), but the source files
are different. When you switch from one .spec file to the other,
these output files will not necessarily get rebuilt automatically,
since they have not been updated. The simple solution is to:

```$ rm SWData.h```

A better solution is probably to have separate build directories
and/or not to store these generated files in the repository.

Note: When directing these two configurations to different
HomeDirs, they need to have different Experiment.config files,
or one that can correct the HomeDir definition.

## Navigation

The purpose of having propellers on the gondola is to be able to
manuever the gondola over relatively short distances relative to
the prevailing winds at altitude. Two propellers should give us
the control we need to apply thrust in whatever direction we
choose. We plan to employ at least two different strategies for
maintaining course. For maintaining a heading, we will use a
simple PID approach. This works fairly well in simulation for
small heading errors. It works for larger changes in direction
as well, but not without a long settling time.

For larger course corrections, we will use a feed-forward approach
where we anticipate how much torque will be required and attempt
to rotate as quickly as possible in order to then apply thrust in
the new direction immediately. This approach has produced excellent
results in simulation. We are looking forward to being able to test
it with the actual hardware.

The direct control of the propellers is abstracted in the nav_pid_t
class defined in nav.cc/.h. The nav_pid object is regularly updated
with the commanded course (Course) and thrust (Nav_Thrust_pct).

At the lowest level, the basic control is set by specifying the average
thrust and a differential thrust parameter, which effectively commands
a torque around the gondola's Z-axis.

For PID control, there is an additional layer, nav_set_rpm_pid(heading),
which takes the current heading as input and calculates the error from
the current course setting. A differential thrust is derived from the
PID processing of this error and passed to nav_set_rpm_dth(dThrust).

For the feed-forward (FF) turns, we perform a pair of opposite torque
manuevers, the first to start rotation and the second to stop it.
The magnitude of the impulses can be controlled by the magnitude of
the differential thrust and the duration that the torque is applied.
That determines the maximum angular velocity that the second impulse
should return to zero. The temporal spacing between the two impulses
also directly affects the ultimate change in heading. The details of
how we will determine the differental thrust, duration and spacing
will depend heavily on our initial experiments.
