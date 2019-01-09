%INTERFACE <PropMtr>
%INTERFACE <Quit>

&start
  : &commands Quit * { nl_error(0, "Shutting down"); }
  : &commands &&Exit
  ;
&&Exit
  : Exit * { /* cgc_forwarding = 0; */ }
  ;
&commands
  :
  : &commands &command
  ;
&command
  : *
  : Log %s (Enter String to Log to Memo) * {}
  ;
 
