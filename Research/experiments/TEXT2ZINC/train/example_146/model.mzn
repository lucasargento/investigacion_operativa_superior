include "globals.mzn";

int: n =  10;
array[0..n-1] of var 0..n-1: s;
array[0..n-1] of int: value = array1d(0..n-1, [i | i in 0..n-1]); % helper for distribute

% solve satisfy;
solve :: int_search(s, first_fail, indomain_min, complete) satisfy;

constraint
   distribute(s, value, s)         /\ 
   sum(i in 0..n-1) (s[i])   = n   /\
   sum(i in 0..n-1) (s[i]*i) = n
;


output [
       show(s), "\n"
];