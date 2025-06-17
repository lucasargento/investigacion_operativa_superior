int: max_i = 4;
int: max_j = 3;
var 1..max_i: index_i;
var 1..max_j: index_j;
array[1..max_i,1..max_j] of var 0..9: matrix;
var 0..8: value;

predicate element_matrix(var int: index_i, 
                         var int: index_j, 
                         array[int,int] of var int: matrix,
                         var int: value) =
                   matrix[index_i,index_j] = value   
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


solve satisfy;

constraint
  
   cp2d(matrix,array2d(1..max_i,1..max_j, [
                        4,1,7,
                        1,0,8,
                        3,2,1,
                        0,0,6
                    ]))
   /\
   index_i = 1
   /\ 
   index_j = 3
   /\
    value = 7
   /\
   element_matrix(index_i,index_j,matrix, value)
;


output
[
  "index_i: " ++ show(index_i) ++ "\n" ++
  "index_j: " ++ show(index_j) ++ "\n" ++
  "value: " ++ show(value) ++ "\n" 
];