%{
  /* Charge.cmd */
  #ifdef SERVER
  /*
    void write_savelog( char *s ) {
      FILE *fp;
      fp = fopen( "saverun.log", "a" );
      if ( fp == 0 ) msg(MSG_ERROR, "Unable to write to saverun.log");
      else {
        fprintf( fp, "%s\n", s );
        fclose( fp );
      }
    }
    
    void write_restart() {
      FILE *fp;
      fp = fopen("restart.txt", "a");
      if (fp == 0) msg(MSG_ERROR, "Unable to create restart.txt");
      else {
        fclose(fp);
      }
    }
  */
  #endif
%}

# We need the transmitting syntax here because it is used
# in the B3MB module. We will not be transmitting
&command
  : &^command
  ;

#&command
#  : Savelog %s (Enter Log Message) * { write_savelog($2); }
# : Request Restart * { write_restart(); }
#  ;
