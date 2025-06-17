include "globals.mzn";
var 1..9: W;
var 1..9: O;
var 1..9: N;
var 1..9: D;
var 1..9: E;
var 1..9: R;
var 1..9: F;
var 1..9: U;
var 1..9: L;

array[1..9] of var int : fd =
  [W,O,N,D,E,R,F,U,L];

var int: WONDERFUL;
var int: OODDF;

% solve satisfy;
solve :: int_search(fd ++ [WONDERFUL, OODDF], 
        first_fail, indomain_min, complete) satisfy;

constraint
  all_different(fd) 
  /\
  WONDERFUL > 0
  /\
  WONDERFUL = 100000000*W + 10000000*O + 1000000*N + 100000*D + 10000*E + 1000*R +  100*F + 10*U + L
  /\
  OODDF = 10000*O + 1000*O + 100*D + 10*D + F
  /\
  OODDF*OODDF = WONDERFUL
  /\
  W >= 1 
  /\
  O >= 1
  
;


output [
  "WONDERFUL: ", show(WONDERFUL), "\n",
  "OODDF: ", show(OODDF)

];