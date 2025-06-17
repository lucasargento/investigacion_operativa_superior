include "globals.mzn";

int: n =  100;
array[0..n-1] of var 0..n-1: s;

% solve satisfy;
solve :: int_search(s, first_fail, indomain_min, complete) satisfy;

constraint
   global_cardinality(s,array1d(0..n-1, set2array(index_set(s))), s) :: domain
;


output [
       show(s), "\n"
];