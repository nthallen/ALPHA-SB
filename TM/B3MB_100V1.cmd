%{
  /* Commands for 100V1 B3MB, CAN ID #1 */
%}

&B3MB_ID <int>
  : 100V1 { $0 = 1; }
  ;