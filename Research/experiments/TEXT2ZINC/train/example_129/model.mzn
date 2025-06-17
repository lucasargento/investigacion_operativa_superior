include "globals.mzn";

int: n = 12;
set of int: classes = 0..n-1;

% Search space: The set of permutations of integer range [0..n-1]
array[classes] of var classes: series;

solve :: int_search(series, first_fail, indomain_median, complete) satisfy;

constraint
  % C1: Each pitch class occurs exactly once
  % GCAD: Exploitation of alldifferent() global constraint
  all_different(series)
  /\

  % C2: Differences between neighbouring notes are all different
  % GCAD: Exploitation of alldifferent() global constraint
  % alldifferent(all (i in classes: i <> n-1) abs(series[i+1] - series[i]));
  all_different( 
         [ abs(series[i+1] - series[i]) | i in classes where i != n-1]
  )
  
;

output [
  show(series)
];