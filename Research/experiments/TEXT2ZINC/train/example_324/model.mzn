int: s = 4;

set of 1..s: S = 1..s;
array[S,S] of var int: x;

solve satisfy;
  
constraint
  forall(i,j in S) ( x[i,j] >= 0)

  /\ % total of 12 pieces placed
  sum(i in S,j in S) (x[i,j]) = 12

  /\ % 5 pieces on each side 
  sum(j in S) (x[1,j]) = 5 /\
  sum(i in S) (x[i,1]) = 5 /\
  sum(j in S) (x[4,j]) = 5 /\
  sum(i in S) (x[i,4]) = 5 

  /\ % inner squares unused 
  sum(i in 2..3,j in 2..3) (x[i,j]) = 0
;

output [
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i,j in S
] ++ ["\n"];