include "globals.mzn"; 
int: s = 3; % 3 working shifts
int: p = 6; % 6 workers

array[1..s] of int: lower = [1,2,2];
array[1..s] of int: upper = [4,3,2];
array[1..p] of string: workers = ["Alan", "Bob", "John", "Mike", "Scott", "Ted"];
        
% Six workers (Alan, Bob, John, Mike, Scott and Ted)
array[1..p] of var 1..s: x;


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
  global_cardinality_low_up(x, [i | i in 1..s], lower, upper)
  /\
  x[1] != 1 % Alan doesn't work on the first shift.
  /\
  x[2] = 3 % Bob works only on the third shift.
;

output [
  "x: " ++ show(x)
]
++
[
  if worker = 1 then "\nShift " ++ show(shift) ++ ": " else "" endif ++
    if (fix(x[worker]) = shift) then 
       show(workers[worker]) ++ " "
    else "" endif
  | shift in 1..s, worker in 1..p
]
 ++ ["\n"]
;