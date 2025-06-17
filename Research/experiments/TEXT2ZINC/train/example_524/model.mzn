int: n = 999;
var 2..n: x;
var 2..n: d1;
var 2..n: d2;

% solve satisfy;
% solve minimize x;
solve :: int_search([x,d1,d2], first_fail, indomain_min, complete) satisfy;

constraint
   x = d1*d2 /\ d1 <= d2
   /\
   forall(i in {2,3,5}) (
      x mod i > 0
   )
;

output [
  "x: " ++ show(x) ++ " (" ++ show(d1) ++ "*" ++ show(d2) ++ ")\n"
]
 ++ ["\n"]
;