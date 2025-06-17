include "globals.mzn"; 

int: n = 8;
set of int: Digits = 0..9;
var Digits: T;
var Digits: O;
var Digits: M;
var Digits: D;
var Digits: A;
var Digits: L;
var Digits: E;
var Digits: Y;

array[1..n] of var Digits: x = [T,O,M,D,A,L,E,Y];
var 10000..99999: DALEY;
var 100..999: TOM = 100*T + 10*O + M;

% convert array <-> number
predicate toNum(array[int] of var int: a, var int: n) =
          let { int: len = length(a) } in
          n = sum(i in 1..len) (
            ceil(pow(10.0, int2float(len-i))) * a[i]
          )
          /\ forall(i in 1..len) (a[i] >= 0)
;


% solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   all_different(x) /\
   T > 0 /\ D > 0 /\
   toNum([D,A,L,E,Y], DALEY) /\
   TOM * 13 = DALEY
;


output
[
  "x: " ++ show(x) ++ "\n" ++
  "DALEY: " ++ show(DALEY)
];