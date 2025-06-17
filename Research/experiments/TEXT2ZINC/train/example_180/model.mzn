include "globals.mzn";

int: n = 52;
int: m = 9;
array[1..m] of var 1..n: x;

% solve satisfy;
solve :: int_search(x, max_regret, indomain_max, complete) satisfy;

constraint
   n = sum(i in 1..m) (x[i])
   % /\ increasing(x) % symmetry breaking
   /\ forall(i in 1..m) (x[i] > 2)
;


output [
 show(x) ++ "\n"
];