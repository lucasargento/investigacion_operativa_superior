include "globals.mzn";

int: k;
set of int: positionDomain = 1..2*k;

array[positionDomain] of var positionDomain: position;
% better presentation:
array[positionDomain] of var 1..k: solution;

solve :: int_search(position, first_fail, indomain_min, complete) satisfy;

constraint
  forall(i in 1..k) (
     position[i+k] = position[i] + i+1 /\
     % hakank: added this
     solution[position[i]] = i /\ 
     solution[position[k+i]] = i
  )
  /\   
  all_different(position)
  /\ % symmetry breaking
  solution[1] < solution[2*k]
;


output [
  show(solution), "\n"

];

%
% data
%
k = 4;
% k = 7;
% k = 8;
% k = 10;
% k = 20;