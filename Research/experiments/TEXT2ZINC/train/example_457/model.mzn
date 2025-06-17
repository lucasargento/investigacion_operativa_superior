include "globals.mzn"; 


int: n = 6;
array[1..n] of var set of 1..n: x;


predicate symmetric(array[int] of var set of int: s) =

  forall(i, j in index_set(s) where i != j) (
    j in s[i] <-> i in s[j]
  )
;

predicate cp1d(array[int] of var set of int: x, array[int] of var set of int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) ( x[i] = y[i] ))
; 

solve satisfy;

constraint
   cp1d(x, 
       [
        {1,2,3},
        {1,3},
        {1,2},
        {5,6},
        {4},
        {4}
    ])
  /\
  symmetric(x)

;


output [
  "x: ", show(x), "\n"
];