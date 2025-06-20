include "globals.mzn"; 
int: rows = 4;
int: cols = 6;
var 0..rows*cols: ticks; % = 18;

% decision variable
array[1..rows, 1..cols] of var 0..1: x;

% solve satisfy;
% solve minimize ticks;
solve :: int_search([x[i,j] | i in 1..rows, j in 1..cols], 
        first_fail, 
        indomain_min, 
        complete) 
    % minimize ticks;
    satisfy;

constraint
   ticks = 18
   /\

   % number of ticks
   sum([x[i,j] | i in 1..rows, j in 1..cols]) = ticks
;


constraint
   % ensure the row constraints: sum >= 1 and even
   forall(i in 1..rows) ( 
      let {
        var 1..cols: s
      } in
      s = sum([x[i,j] | j in 1..cols])
      /\
      s mod 2 = 0
   )

   /\ % ensure the column constraints: sum >= 1 and even
   forall(j in 1..cols) (
      let {
        var 1..rows: s
      } in

      s = sum([x[i,j] | i in 1..rows])
      /\
      s mod 2 = 0
   )


   % /\ % symmetry breaking
   % x[1,1] = 1 /\ x[1,2] = 1
;

output 
[
  "ticks: " ++ show(ticks) ++ "\n"
]
++
[
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i in 1..rows, j in 1..cols
]
 ++ ["\n"]
;