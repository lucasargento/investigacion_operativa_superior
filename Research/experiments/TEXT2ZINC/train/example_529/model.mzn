include "globals.mzn"; 
int: num_persons_per_meeting = 3;
int: num_days = 35;

set of int: persons = 1..15;
array[1..num_days] of var set of persons: days;

solve satisfy;
% solve :: set_search(days, input_order, indomain_min, complete) satisfy;

constraint
  all_different(days)  % different triplets (i.e. day)
  /\
  forall(i in 1..num_days) (
     card(days[i]) = num_persons_per_meeting
  )
  /\ % max 1 common person in each days
  forall(i,j in 1..num_days where i != j) (     
    card(days[i] intersect days[j]) <= 1
  )
;

output [
  show(days), "\n",
]