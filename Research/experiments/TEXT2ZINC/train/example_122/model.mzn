include "globals.mzn";

int: N = 7; 
int: NB = N *(N-1) div 6;
array[1..NB] of var set of 1..N: Sets;

% solve satisfy;
solve::set_search(Sets, first_fail, indomain_min, complete) satisfy;



constraint
   forall(i in index_set(Sets)) (
      card(Sets[i]) = 3
   )
   /\ 
   forall(i,j in index_set(Sets) where i < j) (
      card( Sets[i] intersect Sets[j]) <= 1
   )
   /\ % symmetry breaking
   decreasing(Sets)

;

output [
       "N: ", show(N), " NB: ", show(NB), "\n",
       "Sets: ", show(Sets)
];