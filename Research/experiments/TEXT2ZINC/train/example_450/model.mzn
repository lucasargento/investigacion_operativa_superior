array[1..5] of var 1..8: x;
var 0..100: nvar;
var 0..100: remainder;
var 0..100: quotient;


%
% among_modulo
% 
predicate among_modulo(var int: nvar, array[int] of var int: x, var int: remainder, var int: quotient)=
  nvar = sum(i in index_set(x)) (
    bool2int(x[i] mod quotient = remainder)
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
  cp1d([4,5,8,4,1],x)
  /\
  among_modulo(nvar, x, remainder, quotient)
  /\
  remainder = 0
  /\
  quotient = 2
  % /\
  % nvar = 3
;


output
[
  "x: " ++ show(x) ++ "\n" ++
  "nvar: " ++ show(nvar) ++ "\n" ++
  "remainder: " ++ show(remainder) ++ "\n" ++
  "quotient: " ++ show(quotient) ++ "\n"
];