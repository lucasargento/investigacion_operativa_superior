include "globals.mzn"; 

int: total = 77;
var 1..total: a;
var 1..total: b;
var 1..total: c;

var 1..total: y;


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
    b*a + b*b + (a+b)*c = total 
    /\ y = a + 2*b + c
    /\ y > 0
    /\ a > 0
    /\ b > 0
    /\ c > 0
;

output ["y=\(y)"]; % this only show a single solution: y=18