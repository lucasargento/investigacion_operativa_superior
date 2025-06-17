include "globals.mzn"; 

int: num_steps = 5; % i.e. the persistence
int: max_size = num_steps;

% decision variables
var 0..pow(10,max_size)-1: num; % the number to start with

array[0..num_steps, 1..max_size] of var 0..9: x;
array[0..num_steps] of var 1..pow(10,max_size)-1: nums;

% functions
function var int: to_num_base(array[int] of var int: a, int: base) =
          let { int: len = card(index_set(a));
                var int: n = sum(i in index_set(a)) (
                   pow(base, len-i) * a[i] 
                 );
         } in n
;

% base 10
function var int: to_num(array[int] of var int: a) = to_num_base(a, 10);

% solve satisfy;
solve minimize num;
% solve maximize num;
% solve :: int_search(array1d(x) ++ nums, first_fail, indomain_split, complete) minimize num;

constraint
  nums[0] = num /\
  nums[0] = to_num([x[0,i] | i in 1..max_size]) /\
  forall(s in 1..num_steps) (
    % note: don't multiply with leading 0's
    nums[s] = product([if x[s-1,i] > 0 then x[s-1,i] else 1 endif | i in 1..max_size]) 
    /\
    nums[s] = to_num([x[s,i] | i in 1..max_size])
  )
  
  /\ % we want a solution in exactly num_steps steps
  nums[num_steps] != nums[num_steps-1] 

  % redundant constraints
  /\ % requires that last number is a single digit
  forall(i in 1..max_size-1) ( x[num_steps,i] = 0)

  /\ nums[num_steps] < 10
  % /\ decreasing(nums) % much faster
;

output [
  "nums: \(nums)\n"
]
++
[
  if i = 1 then "\n" else " " endif ++
    show(x[s,i])
  | s in 0..num_steps, i in 1..max_size
]
;