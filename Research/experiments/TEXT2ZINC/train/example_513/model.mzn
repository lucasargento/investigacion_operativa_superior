include "globals.mzn"; 


var 7..7: T; % hardwired to 7
var 0..9: W;
var 0..9: O;
var 1..9: F; % > 0
var 0..9: U;
var 0..9: R;

array[1..6] of var 0..9: FD = [T,W,O,F,U,R];

solve satisfy;

constraint
   alldifferent(FD)
   /\
   2 * (100*T + 10*W + O) = 1000*F + 100*O + 10*U + R
   /\  
   O mod 2 = 0
;

output [
       
       show(T), show(W), show(O), " + ", show(T), show(W), show(O), " = ",
       show(F), show(O), show(U), show(R), "\n",
       "W: ", show(W), "\n"
]