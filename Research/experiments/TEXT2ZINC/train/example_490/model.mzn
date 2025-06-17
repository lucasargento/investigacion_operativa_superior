include "globals.mzn"; 

int: n = 9; % the farmer and cows problem

% decision variables
array[1..n] of var 1..n*n: x;
var 0..n*n*n: z = sum(x);


% solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   alldifferent(x) /\
   increasing(x) /\
   x[n] - x[1] = n-1

   % "identify constraint"
   % identify the sequence for the "farmer and cows" solution
   /\ z = n*(n*n + 1) div 2
;

output [
  "z: " ++ show(z) ++ "\n" ++
  "x: " ++ show(x) ++ "\n"
];