include "globals.mzn"; 
int: n = 5;
array[1..n] of var 1..n: variables;
var 1..n: t_min;
solve satisfy;

%
% This is more complicated than max_nvalue 
% (http://www.hakank.org/minizinc/max_nvalue) since the minimum value
% in the occurrence array maybe 0 and must be handled.
%
predicate min_nvalue(var int: tt_min, array[int] of var int: variables) =
    let {
        array[min(index_set(variables))..max(index_set(variables))] of var 0..length(variables): occ
    } in
    % global_cardinality_old(variables, occ)
   global_cardinality(variables, array1d(min(index_set(variables))..max(index_set(variables)), [i | i in min(index_set(variables))..max(index_set(variables))]), occ)
    /\ % some value in occ is larger than 0 and less than any other
       % values (larger than 0)
    forall(i in index_set(occ)) (
      occ[i] > 0 -> t_min <= occ[i]
    )
    /\ % and now we find exactly which value that is
    exists(i in index_set(occ)) (
      t_min = occ[i]
    )
;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

constraint
   % cp1d(variables, [9,1,7,1,1,7,7,7,7,9])
   % /\
   t_min = 2
   /\
   min_nvalue(t_min, variables) 

;

output
[
  "variables: " ++ show(variables) ++ "\n" ++
  "t_min: " ++ show(t_min) ++ "\n"
];