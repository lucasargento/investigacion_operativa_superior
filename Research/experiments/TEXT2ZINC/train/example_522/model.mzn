include "globals.mzn"; 
set of int: S = {-7,-5,-3,-2,2,4,6,13};

var S: a;
var S: b;
var S: c;
var S: d;
var S: e;
var S: f;
var S: g;
var S: h;

array[1..8] of var S: x = [a,b,c,d,e,f,g,h];

var int: V;

% solve satisfy;
% solve minimize V;
solve :: int_search(x, 
        max_regret, 
        indomain_min, 
        complete) minimize V;

constraint
  alldifferent(x) 
  /\
  V = (a+b+c+d)*(a+b+c+d) + (e+f+g+h)*(e+f+g+h)

  /\ % symmetry breaking
  increasing([a,b,c,d])
  /\
  increasing([e,f,g,h])
  /\
  a < e
;

output [
  "x: " ++ show(x) ++ "\n" ++
  "V: " ++ show(V)
]
 ++ ["\n"]
;