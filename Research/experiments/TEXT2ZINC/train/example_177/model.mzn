int: n = 4;

% comment the output for counting larger values of n
array[1..n, 1..n] of var 0..1: x;
array[1..n] of var 0..n: sum_rows;

solve :: int_search([x[i,j] | i,j in 1..n] ++ sum_rows, first_fail, indomain_min, complete) satisfy;

constraint

  % We are going to put n checkers on an (n x n) checkers board, 
  sum([x[i,j] | i,j in 1..n]) = n

  /\ % In each column there is EXACTLY one checker.
  forall(j in 1..n) (
      sum([x[i,j] | i in 1..n]) = 1
  )

  /\ % For i=1,2,...,(n-1), the first i rows cannot have EXACTLY i checkers.
  forall(i in 1..n) (
    % number of checker on each row 
    sum_rows[i] = sum([x[i,j] | j in 1..n])
  )
  /\
  forall(i in 1..n-1) (
      sum([sum_rows[j] | j in 1..i]) != i
  ) 
;

output 
[
  "sum_rows: " ++ show(sum_rows) ++ "\n"
] 
++
[
  if j = 1 then  "\n" else " " endif ++
    show(x[i,j])
  | i, j in 1..n
]
++ 
["\n"];