include "globals.mzn"; 
int: n = 5;
array[1..n] of var 0..50: bales;

array[1..10] of int: weights = [80, 82, 83, 84, 85, 86, 87, 88, 90, 91];

% solve satisfy;
solve :: int_search(bales, occurrence, indomain_min, complete) satisfy;

constraint
   forall(w in 1..10) (
     let {
        var 1..n: i,
        var 1..n: j
     } in
       i < j /\
       bales[i] + bales[j] = weights[w]
   )
   /\ increasing(bales)
;


output [
  % "bales: " ++ show(bales) ++ "\n"
  "bale" ++ show(i) ++ ": " ++ show(bales[i]) ++ "\n"
  | i in 1..n
] ++ ["\n"];