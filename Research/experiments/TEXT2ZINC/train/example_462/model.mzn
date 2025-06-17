int: n = 4;
int: m = 2;
array[1..n, 1..m] of var 0..1: arr;
array[1..m] of var 0..1: v1;
var 1..n: pos;

%
% adding an index parameter: in which position is v?
% This is in effect the same as the global constraint cond_lex_cost
%
predicate cond_lex_cost(array[int] of var int: v, array[int, int] of var int: a, var int: ix) =
      exists(i in index_set_1of2(a)) (
      ix = i
      /\
      forall(j in index_set(v)) (
         a[i,j] = v[j]
      ) 
    )
;

predicate cp2d(array[int,int] of int: x, array[int,int] of var int: y) =
  assert(index_set_1of2(x) = index_set_1of2(y) /\
         index_set_2of2(x) = index_set_2of2(y),
           "cp2d: x and y have different sizes",
      forall(i in index_set_1of2(x), j in index_set_2of2(x)) (
         y[i,j] = x[i,j]
     ) 
  )
; 

predicate cp1d(array[int] of int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) ( x[i] = y[i] ) )
; 


solve satisfy;

constraint
%    cp1d([0,1], v1)
%    /\
    cp2d([|1,0,
           |0,1,
           |0,0
           |1,1|], arr)
    /\
    cond_lex_cost(v1, arr, pos)
;

output
[
  "arr: " ++ show(arr) ++ "\n" ++
  "v1: " ++ show(v1) ++ "\n" ++
  "pos: " ++ show(pos) ++ "\n" 
];