array[1..3] of var int: x; % >= 0;

solve minimize x[3]; 
constraint
   forall(i in 1..3) (
     x[i] >= 0
   )
   /\
   10000*x[1] + 6790 + x[2] = 72*x[3]
   /\
   forall(i in 1..2) (
     x[i] <= 9
   )
   /\
   x[3] <= 1345
;

output
[
  show(x)
];