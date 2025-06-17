int: n = 5;
array[1..n, 1..2] of var 1..5: pairs;
var lb_array(pairs)..ub_array(pairs): npairs;

predicate npair(var int: npairs, array[int,int] of var int: pairs) =
    let {
       array[lb_array(pairs)..ub_array(pairs)] of var 0..1 : first_pos
    } in
    forall(i in index_set_1of2(pairs)) (
       first_pos[i] = 1 <-> 
           forall(j in lb_array(pairs)..i-1) (
               not(
                   pairs[i,1] = pairs[j,1]
                   /\
                   pairs[i,2] = pairs[j,2]
               )
           )
    )
    /\
    npairs = sum(first_pos)
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
   npairs = 2 /\
   cp2d(pairs, array2d(1..n,1..2, [
                       3,1,
                       1,5,
                       3,1,
                       3,1,
                       1,5
                  ]))
    /\
    npair(npairs, pairs)
;

output
[
  "npairs: " ++ show(npairs) ++ "\n" ++ 
  "pairs: " ++ show(pairs) ++ "\n" 
];