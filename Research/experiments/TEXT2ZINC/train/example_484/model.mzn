include "globals.mzn"; 
int: n = 5;

array[1..n] of var 1..n: x;
var lb_array(x)..ub_array(x): pos;

% p is the position of the maximum element
predicate argmax_gt(var int: p, array[int] of var int: x) =
  forall(i in index_set(x)) ( p != i -> (x[p] > x[i]) )
; 

% p is the position(s) of the maximum element(s)
predicate argmax_ge(var int: p, array[int] of var int: x) =
  forall(i in index_set(x)) ( x[p] >= x[i] )
; 

% p is the position of the minimum element
predicate argmin_lt(var int: p, array[int] of var int: x) =
  forall(i in index_set(x)) ( p != i -> (x[p] < x[i]) )
; 

% p is the position(s) of the minimum element(s)
predicate argmin_le(var int: p, array[int] of var int: x) =
  forall(i in index_set(x)) ( x[p] <= x[i] )
; 


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
  alldifferent(x) /\
  argmax_gt(pos,x) /\
  % pos = 1 /\
  argmin_lt(2,x) 
;

output
[
  "x: " ++ show(x) ++ "\n" ++
  "pos: " ++ show(pos) ++ "\n"
  
];