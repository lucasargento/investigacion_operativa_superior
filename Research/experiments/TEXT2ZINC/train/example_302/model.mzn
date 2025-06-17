array[1..4] of var int: x;
var int: n;

solve minimize n;

constraint
   forall(i in 1..4) (x[i] >= 1)  /\
   n >= 1 /\
   -3*x[1] + n = 1 /\
   -4*x[2] + n = 2 /\
   -5*x[3] + n = 3 /\
   -6*x[4] + n = 4
;

output [
"x: " ++ show(x) ++ "\n"++
"n: " ++ show(n) ++ "\n"
];