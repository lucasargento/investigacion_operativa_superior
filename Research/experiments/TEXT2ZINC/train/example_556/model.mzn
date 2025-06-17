include "globals.mzn"; 
% include "globals-gecode.mzn"; 

int: num_skis = 6;
int: num_skiers = 5;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% the assignments
array[1..num_skiers] of var 1..num_skis: x;

% minimize the differences
% var int: z = sum(i in 1..num_skiers) ( abs(ski_heights[x[i]] - skier_heights[i]) );
% Without the element constraint
var int: z = sum(i in 1..num_skiers, j in 1..num_skis) (
             bool2int(x[i] = j) * abs(ski_heights[j] - skier_heights[i]) 
    );

% solve satisfy;
solve :: int_search(x, smallest, indomain_min, complete)  minimize z;

constraint
   % z = 7 /\ % for original problem
   all_different(x) % :: domain
;

ski_heights =   [1, 2, 5, 7, 13, 21]; % original problem
skier_heights = [3, 4, 7, 11, 18];

output [
  show(z) ++ "\n" ++
  show(x) ++ "\n"
];