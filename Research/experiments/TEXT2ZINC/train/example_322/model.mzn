include "globals.mzn"; 
int: n = 3; 
int: m = 2*n;
array[1..m] of var 1..m: x;

solve :: int_search(x, first_fail, indomain_split, complete) satisfy;

constraint
   alldifferent(x)
   /\
   forall(i in 2..m) (
     (x[i] mod 2 = x[i-1] mod 2)
     \/
     exists(j in 1..n) (
        (2*(j-1)+1 = x[i] /\ 2*(j-1)+2 = x[i-1]) 
        \/
        (2*(j-1)+1 = x[i-1] /\ 2*(j-1)+2 = x[i]) 
     )
  )
;


output [
 "x     : " ++ show(x) ++ "\n" 
] ++ ["\n"];