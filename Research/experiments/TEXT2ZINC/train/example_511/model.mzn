include "globals.mzn"; 

int: n = 5;
array[1..n] of var 0..1000: x;


% solve satisfy;
solve :: int_search(x, first_fail, indomain_split, complete) satisfy;

constraint
   all_different(x)
   /\
   increasing(x)
   /\
   forall(i, j in 1..n where i !=j) (
     let {
       var 0..10000: p
     } 
     in
      p*p-1 = (x[i]*x[j])
   )

   /\
   (
     (x[1] < 1 /\ x[2] = 1 /\ x[3] = 3 /\ x[4] = 8 /\ x[5] = 120)
     \/ 
     (x[1] = 1 /\ x[2] = 3 /\ x[3] = 8 /\ x[4] = 120 /\ x[5] > 120)
   )
;

output [
  show(x),"\n",

];