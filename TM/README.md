# SCoPEx TM
For this experiment, we are experimenting with actively supporting two different telemetry frames within the same source directory. There are two different .spec files, scopex.spec and scopexsim.spec. With more than one .spec file, appgen must be invoked with an explicit argument:

```$ appgen scopex.spec```

scopex.spec is the main instrument definition, including all peripheral devices operating at the anticipated flight data rate. scopexsim.spec eliminates the B3MB data from the frame and operates the PropMtr and SpatialDual data at a higher rate to improve the precision of the scopexsim kinematic model.

It is possible to run simulations using the full instrument definition as well. As currently configured, the simulation startup (runfile.sim) does not attempt to run real device drivers (SpatialDual, PropMtr, B3MB), although it will run comms drivers if configured to do so.
