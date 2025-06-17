include "globals.mzn"; 
int: n = 4;
array[1..n] of var 1..n: variables;
array[1..n, 1..n] of var 0..9: matrix;
var 0..1000: cost;

predicate minimum_weight_alldifferent(array[int] of var int: variables,
                                      array[int,int] of var int: matrix,
                                      var int: cost) =
   all_different(variables)
   /\
   cost = sum(i in index_set(variables)) (
      sum(j in index_set_2of2(matrix)) (
         bool2int(variables[i] = j)*matrix[i,j]
      )
   )
;

predicate cp2d(array[int,int] of var int: x, array[int,int] of var int: y) =
  assert(index_set_1of2(x) = index_set_1of2(y) /\
         index_set_2of2(x) = index_set_2of2(y),
           "cp2d: x and y have different sizes",
     forall(i in index_set_1of2(x), j in index_set_2of2(x)) (
         y[i,j] = x[i,j]
    ) 
  )
; 

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

solve minimize cost;

constraint
   cp1d(variables, [2,3,1,4]) % /\
   % cp2d(matrix, array2d(1..n, 1..n, [
   %                 4,1,7,0,
   %                 1,0,8,2,
   %                 3,2,1,6,
   %                 0,0,6,5
   %             ]))
   /\
   cost = 17
   /\
   minimum_weight_alldifferent(variables, matrix, cost)
;


output
[
  "variables: " ++ show(variables) ++ "\n" ++
  "cost: " ++ show(cost) ++ "\n" ++
  "matrix: " ++ show(matrix) ++ "\n"
];