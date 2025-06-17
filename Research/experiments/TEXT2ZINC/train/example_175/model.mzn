include "globals.mzn";

int: k;
set of int: positionDomain = 1..2*k;

array[positionDomain] of var positionDomain: position;
% better presentation:
array[positionDomain] of var 1..k: solution;

solve :: int_search(
        position, 
        first_fail, 
        indomain_min, 
        complete) satisfy;

constraint 
    assert( k mod 4 == 0 \/ k mod 4 = 3, "k mod 4 = 0 or k mod 4 = 3")
;

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
  % "position: ", show(position), "\n",
  "solution: ", show(solution), "\n"
];

%
% data
%


% k mod 4 = 0 \/ k mod 4 = 3
%
k = 4;
% k = 7;
% k = 8;
% k = 11;
% k = 12;
% k = 15;
% k = 16;
% k = 19;
% k = 20;
% k = 23;
% k = 24;
% k = 27;
% k = 35;