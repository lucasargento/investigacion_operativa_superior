include "globals.mzn"; 
int: num_work;
int: num_shifts;
int: min_num_shifts;
array[1..num_shifts] of set of int: shifts;

array[1..num_shifts] of var 0..1: x;
var 0..num_shifts: tot_shifts;

% solve minimize tot_shifts;
solve :: int_search(
        x ++ [tot_shifts], 
        first_fail, 
        indomain_min, 
        complete) 
    minimize tot_shifts;
    % satisfy;

constraint
   tot_shifts = sum(x)
   /\
   forall(j in 0..num_work-1) (
       sum(i in 1..num_shifts) (x[i]*bool2int(j in shifts[i])) = 1
   )
   /\
   tot_shifts >= min_num_shifts

   %/\ % for solve satisfy (t1)
   %tot_shifts = 7
;


output [
  "tot_shifts: " ++ show(tot_shifts) ++ "\n" ++ 
  "x: " ++ show(x) ++ "\n"
] ++ 
[
  if fix(x[i]) = 1 then show(shifts[i]) else "" endif
  | i in 1..num_shifts
] ++ 
["\n"] ++
[
  if fix(x[i]) = 1 then show(i) ++ " " else "" endif
  | i in 1..num_shifts
] ++ ["\n"];