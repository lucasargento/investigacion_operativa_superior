int: coin = 3;
set of int: C = 1..coin;
array[C] of var int: x;
array[C] of int: value = [30,12,6];

solve satisfy;

constraint
   forall(i in C) (x[i] >= 1) 
   /\
   sum(i in C) (value[i]*x[i]) = 306
   /\ 
   sum(i in C) (x[i]) = 15
;


output [
  "x: ", show(x)
];