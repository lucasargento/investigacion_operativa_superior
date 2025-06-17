int: n = 9;
int: num_subsets = 2;
array[1..n] of int: s = [3, 1, 1, 2, 2, 1, 5, 2, 7];

% decision variables

% to which subset does x[i] belong
array[1..n] of var 1..num_subsets: x;


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

% Hardcoded for 2 subsets
% constraint
%    sum([s[i]*bool2int(x[i] == 1) | i in 1..n]) == 
%    sum([s[i]*bool2int(x[i] == 2) | i in 1..n])
%    /\ % symmetry breaking
%    x[1] = 1
% ;

% More general
constraint
   forall(p in 1..num_subsets-1) (
      sum([s[i]*bool2int(x[i] == p) | i in 1..n]) == 
      sum([s[i]*bool2int(x[i] == p+1) | i in 1..n])
   )
;

% symmetry breaking
constraint
   x[1] = 1
;


output [
  "s: " ++ show(s) ++ "\n" ++
  "x: " ++ show(x) ++ "\n"
]
++
[
  "subset" ++ show(j) ++ ": " ++ show([s[i] | i in 1..n where fix(x[i]) == j]) ++ "\n"
  | j in 1..num_subsets
] 
;