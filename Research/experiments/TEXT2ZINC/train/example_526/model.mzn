include "globals.mzn"; 

set of 1..9: d = 1..9;
var d: A;
var d: B;
var d: C;
var d: D;
var d: E;
var d: F;
var d: G;
var d: H;
var d: I;

var int: s; % the sum

array[d] of var d: x = [A,B,C,D,E,F,G,H,I];


% solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) maximize s;

constraint

   all_different(x)

   /\
   s = (100*A + 10*B + C) * (10*D + E) 
   /\
   s = (10*F + G) * (10*H + I) 
   /\
   (10*F + G) <= (10*H + I)  % symmetry breaking
   /\
   s = 7448
;


output [
  "Solution:\n",
  "  ", show(A), show(B), show(C), "\n",
  "*  ", show(D), show(E), "\n",
  "-----\n",
  " ", show(s), "\n",
  "\n", 
  "   ", show(F), show(G), "\n",
  " * ", show(H), show(I), "\n",
  "-----\n",
  " ", show(s),"\n",

];