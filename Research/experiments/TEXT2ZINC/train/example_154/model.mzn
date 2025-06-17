include "globals.mzn";

int: n = 4;
int: r  = 1; % red
int: ry = 2; % red-yellow
int: g  = 3; % green
int: y  = 4; % yellow

set of int: Cars = {r,ry,g,y};
set of int: Pedestrians = {r,g};

array[1..4, 1..4] of Cars: allowed;

array[1..n] of var Cars: V;
array[1..n] of var Pedestrians: P;


solve satisfy;

constraint
 forall(i in 1..n, j in 1..n where j = (1+i) mod 4)  (
   table([V[i], P[i], V[j], P[j]], allowed)
 )
;


allowed = array2d(1..4, 1..4, 
[
 r,r,g,g, 
 ry,r,y,r, 
 g,g,r,r, 
 y,r,ry,r
]);


% output [
%  "V: ", show(V), "\nP: ", show(P), "\n"
% ];
output [
 show(V[i]) ++ " " ++ show(P[i]) ++ " "
  | i in 1..n
] ++ ["\n"];