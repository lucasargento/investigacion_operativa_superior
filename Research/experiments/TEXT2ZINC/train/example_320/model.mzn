int: door = 2;
int: prize = 2;	% 1 = Lady, 2 = Tiger

set of 1..door: D = 1..door;
set of 1..prize: P = 1..prize;
array[D,P] of var 0..1: x;   % x(i,j) = 1 if door i hides prize j, else 0
array[D] of var 0..1: t;     % t(i) = 1 if statement on door i is true, else 0

solve satisfy;

constraint
  % each door hides 1 prize
  forall(i in D) (
    sum(j in P) (x[i,j]) = 1
  )
  /\
  % if door i hides prize i then statement i is true else false
  forall(i in D) (
     x[i,i] = t[i]
  )
  /\ % if statement on door 1 is true [i.e. x[1,1]+x[2,1]>=2] then set t[1] = 1, else t[1] = 0
  x[1,1]+x[2,1]-t[1] <= 0 /\
  x[1,1]+x[2,1]-t[1] >= 0 

  /\ % if statement on door 2 is true then set t[2] = 1, else t[2] = 0
  x[1,1] = t[2]
;

output 
[
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i in D, j in P
] ++
[
 if i = 1 then "\n" else "" endif ++
 show(t[i]) ++ "\n"
 | i in D
];