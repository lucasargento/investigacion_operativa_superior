include "globals.mzn"; 

int: n = 10;

var 0..9: G;
var 0..9: A;
var 0..9: T;
var 0..9: H;
var 0..9: E;
var 0..9: R;
var 0..9: O;
var 0..9: M;
var 0..9: I;
var 0..9: N;

array[1..n] of string: s = ["G","A","T","H","E","R","O","M","I","N"]; 

% decision variables
array[1..n] of var 0..9: x = [G,A,T,H,E,R,O,M,I,N];

solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   alldifferent(x) /\

   100000*G + 10000*A + 1000*T + 100*H + 10*E + R + 
   100000*H + 10000*O + 1000*M + 100*A + 10*G + E = 
   100000*M + 10000*A + 1000*R + 100*T + 10*I + N

   /\ % These are not needed for uniqueness
   A*A = H
   /\
   G*G = O

   % The first digits in each word must not be 0.
   % (though it don't make any difference for the solution).
   /\ 
   G > 0 
   /\
   H > 0 
   /\
   M > 0
;

output 
[
  "x: " ++ show(x) ++ "\n"
]
++
[ show(s[i]) ++ ": " ++ show(x[i]) ++ "\n"
  | i in 1..n
];