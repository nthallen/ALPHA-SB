# KK-SCoPEx: SCoPEx Flight Instrument Software

This project currently includes three different builds:
 - TM/scopex.spec: The full flight configuration
 - TM/scopexsim.spec: A version for realtime simulation of navigatoin control
 - Charge/Charge.spec: For managing the battery systems

While the Charge project is in a separate directory, scopex and scopexsim are
located in the same directory. When shifting from one build to the other, the
standard approach should be:

```
src/TM $ make clean-dist
src/TM $ appgen scopexsim
src/TM $ make all-dist
...
src/TM $ make clean-dist
src/TM $ appgen scopex
src/TM $ make all-dist
```
