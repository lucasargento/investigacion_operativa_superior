include "globals.mzn"; 
int: n = 12;
% int: n = 7; % For the Ruby Quiz example
int: num_families = 4;

array[1..n] of 1..num_families: family = [1,1,1,1, 2, 3,3,3,3,3, 4,4];
% Ruby Quiz example:
% array[1..n] of 1..num_families: family = [1,1,2,2, 3, 4,4];

% decision variables
array[1..n] of var 1..n: x;


% Ensure that there are no fix points in the array.
predicate no_fix_points(array[int] of var int: x) =
  forall(i in index_set(x)) ( 
     x[i] != i
  )
;

solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
  % Everyone gives and receives a Secret Santa
  all_different(x) 

  /\ % Can't be one own's Secret Santa
  no_fix_points(x) 

  /\ % No Secret Santa to a person in the same family
  forall(i in index_set(x)) (
     family[i] != family[x[i]]
  )
; 


output [
   "Person " ++ show(i) ++ " (family: " ++ show(family[i]) ++ ") is a Secret Santa of " ++ show(x[i]) ++ " (family: " ++ show(family[x[i]]) ++ ")\n"
   | i in 1..n
] ++ 
["\n"];