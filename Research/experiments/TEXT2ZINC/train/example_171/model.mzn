int: n = 6; % must be even
int: m = n div 2;

array[1..n, 1..n] of var 0..1: x;


solve satisfy;

constraint
   assert(n mod 2 = 0, "n must be even")
   /\
   forall(i in 1..n) (
        sum(j in 1..n) (bool2int(x[i,j]=1)) = m
   )
   /\
   forall(j in 1..n) (
        sum(i in 1..n) (bool2int(x[i,j]=1)) = m
   )
;

output [
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i,j in 1..n
] ++ ["\n"];