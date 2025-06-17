int: n = 3;
int: m = 2;
array[1..n] of var 1..8: variables;
array[1..m] of var 1..8: values;
var 0..8: nvar;

predicate cardinality_atleast(var int: nvar, array[int] of var int: variables, array[int] of var int: values) =
   forall(i in index_set(values)) (
     sum(j in index_set(variables)) (bool2int(values[i] = variables[j])) >= nvar
   )

;

predicate cp1d(array[int] of int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) (
        x[i] = y[i]
    )
  )
; 


solve satisfy;

constraint

   cp1d([3,3,8],variables)
   /\
   cp1d([3,8], values)
   /\
   nvar = 1
   /\
   cardinality_atleast(nvar, variables, values)
;

output
[
  "variables: " ++ show(variables) ++ "\n" ++
  "nvar: " ++ show(nvar) ++ "\n" ++ 
  "values: " ++ show(values)
];