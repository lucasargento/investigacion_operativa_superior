include "globals.mzn"; 

int: n = 7;
int: m = 30;

int: Limit; 
array[1..n] of 1..m: LD; % duration
array[1..n] of 1..m: LR; % resources

% decision variables
var int: End; % to minimize
array[1..n] of var 1..m: LO; % origin (start)
array[1..n] of var 1..m: LE; % end times


% solve satisfy;
% solve minimize End;
solve :: int_search(LE, 
        anti_first_fail, indomain_min, complete) minimize End;

constraint
  % End <= 23 % for solve satisfy
  % /\
  forall(i in 1..n) (
      LO[i] + LD[i] = LE[i] 
  )
  /\
  maximum(End, LE)
  /\
  cumulative(LO, LD, LR, Limit)

;


output [
  "Max end time: ", show(End), "\n",
  "Origin      : ", show(LO), "\n",
  "Duration    : ", show(LD), "\n",
  "Resources   : ", show(LR), "\n",
  "End times   : ", show(LE), "\n",

];

%
% data
%

LD = [16, 6,13, 7, 5,18, 4];
LR = [ 2, 9, 3, 7,10, 1,11];
Limit = 13;