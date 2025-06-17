include "globals.mzn"; 

int: k = 8;

array[1..k] of int: free; % time to free each knight
array[1..k] of int: prep; % time to prepare each knight
int: time_limit;

array[1..k] of var 0..20: start; % start times
array[1..k] of var 0..100: end; % end times
array[1..k] of var 0..1: rescued; % which knigth to be rescued
var 0..k: z = sum(rescued); % number of knights rescused

solve :: int_search(start ++ rescued, first_fail, indomain_split, complete) maximize z;
% solve :: int_search(start ++ rescued, first_fail, indomain_split, complete) satisfy;

constraint  

  forall(i in 1..k) (
     end[i] = start[i] + free[i] + prep[i] 
     /\
     (end[i] <= time_limit <-> rescued[i] = 1)
  )
  /\
  cumulative(start,free,[1 | i in 1..k], 1)
 
  % /\ z = 6 
;

output 
[
  "start  : ", show(start), "\n",
  "free   : ", show(free), "\n",
  "prep   : ", show(prep), "\n",
  "end    : ", show(end), "\n",
  "rescued: ", show(rescued), "\n",
  "z      : ", show(z),"\n"
];

%
% data
%
free = [1, 1, 2,2, 3, 4, 5,6];
prep = [15,5,15,5,10,15,10,5];
time_limit = 20;