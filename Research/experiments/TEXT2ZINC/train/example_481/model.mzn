include "globals.mzn"; 
int: n = 6;
array[1..n] of var 1..n: x;
% array[1..n] of var 0..n: transpositions; % number of reversals
var 0..n: perm_num; % if the permutation is even/odd
var 0..1: even_odd; % if the permutation is even/odd

predicate permutation_number(array[int] of var int: x, var int: perm_num) =
  let {
    int: n = card(index_set(x)),
    array[1..n] of var 0..n: transpositions2
  } in
  forall(i in 1..n) (
     % count the number of elements in i+1 which are lower than
     % x[i]. This is the number of reversals
     transpositions2[i] = sum(j in i+1..n) (
        bool2int(x[j] < x[i])
     )
  )
  /\
  perm_num = sum(transpositions2)

;

% solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;


constraint
  all_different(x)
  /\
  permutation_number(x, perm_num)
  /\
  even_odd = perm_num mod 2
  %/\ perm_num = 2
  %/\ perm_num = 1
 
;

output
[
  "x: " ++ show(x) ++ "\n" ++
  "perm_num: " ++ show(perm_num) ++ "\n" ++
  "even_odd: " ++ show(even_odd) ++ "\n"
];