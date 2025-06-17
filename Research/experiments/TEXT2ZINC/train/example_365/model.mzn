include "globals.mzn"; 

int: n = 7;
int: max_val = 100;

% decision variables
array[1..n] of var 1..max_val: x;
var 1..max_val*n: z;



% solve satisfy;
solve :: int_search(x, max_regret, indomain_min, complete) satisfy;

constraint
  alldifferent(x) /\

  % ordered
  increasing(x) /\

  z = sum(x) /\

  z mod n = 0 /\

  forall(i,j in 1..n where i < j) (
    %  abs(x[i]-x[j]) > 1 /\ % extra: not allowing differences of 1.
    z mod abs(x[i]-x[j]) = 0
  )
;

output
[
  "x: " ++ show(x) ++ "\n" ++
  "z: " ++ show(z) ++ "\n" 
];