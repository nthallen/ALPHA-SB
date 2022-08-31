# SCoPEx TM
For this experiment, we are experimenting with actively supporting
two different telemetry frames within the same source directory.
There are two different .spec files, scopex.spec and scopexsim.spec.
With more than one .spec file, appgen must be invoked with an explicit
argument:

```$ appgen scopex.spec```

scopex.spec is the main instrument definition, including all
peripheral devices operating at the anticipated flight data rate.
scopexsim.spec eliminates the B3MB data from the frame and operates
the PropMtr and SpatialDual data at a higher rate to improve the
precision of the scopexsim kinematic model.

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
