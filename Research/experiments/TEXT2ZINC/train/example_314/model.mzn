int: door  = 2;
int: prize = 2;  % 1 = Lady, 2 = Tiger

array[1..door, 1..prize] of var 0..1: x; % x(i,j) = 1 if door i hides prize j, else 0
array[1..door] of var 0..1: t;        %  t(i) = 1 if statement on door i is true, else 0

solve satisfy;

constraint
  % each door hides 1 prize
  forall(i in 1..door) (
    sum(j in 1..prize) (x[i,j]) = 1
  )
  /\
  % if statement on door 1 is true then t[1] = 1, else t[1] = 0
  x[1,1]+x[2,1]-2*t[1] <= 0  /\
  x[1,1]+x[2,1]-t[1] >= 0 /\

  % if statement on door 2 is true then t[2] = 1, else t[2] = 0
  t[2] = x[1,2] /\
        
  % statements either both true or both false
  t[1] = t[2]
;

output 
[
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i in 1..door, j in 1..prize
] ++
[
 if i = 1 then "\n" else "" endif ++
 show(t[i]) ++ "\n"
 | i in 1..door
];