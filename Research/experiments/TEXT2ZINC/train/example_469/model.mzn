include "globals.mzn"; 

int: n = 5;
array[1..n] of var 1..3: x;
var set of 1..5: s;
var set of 1..8: t;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

solve satisfy;

constraint
  cp1d(x, [1,3,1,2,3])
  /\
  s = {2,4,5}
  /\
  t = {2,3,8}
  /\
  roots(x, s, t)
;


output [
"x: " ++ show(x) ++ "\n"++
"s: " ++ show(s) ++ "\n"++
"t: " ++ show(t) ++ "\n"
];