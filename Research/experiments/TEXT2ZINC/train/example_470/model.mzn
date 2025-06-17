include "globals.mzn"; 

int: n = 5;
array[1..n] of var 1..7: x;
var 0..n: num_class;
array[1..3] of var set of 1..7: s;

predicate nclass(var int: nc, 
                 array[int] of var int: v, 
                 array[int] of var set of int: s) =
   all_disjoint(s)
   /\
   num_class = sum(i in index_set(s)) (
     bool2int(
        exists(j in index_set(v)) (
           v[j] in s[i]
        )
     )
   )
;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

predicate cp1d(array[int] of var set of int: x, array[int] of var set of int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) ( x[i] = y[i] ))
; 

solve satisfy;

constraint
   cp1d(s, [
          {1,3},
          {4},
          {2,6}
       ])
   /\
   cp1d(x, [3,2,7,2,6])
   /\
   num_class = 2
   /\
   nclass(num_class, x, s)
;

output
[
  "x: " ++ show(x) ++ "\n" ++
  "s: " ++ show(s) ++ "\n" ++
  "num_class: " ++ show(num_class)

];