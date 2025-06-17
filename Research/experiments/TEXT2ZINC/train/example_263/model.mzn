include "globals.mzn";

% the size of the sequence
int: n;

% the sequence
array[0..n-1] of var 0..n-1: x;

% the interval sequence
array[1..n-1] of var 1..n-1: y;

% each pitch-class occurs exactly once
constraint alldifferent(x);

% the musical intervals between neighboring notes cover the full set of intervals
constraint alldifferent(y);

% calculate the interval sequence
constraint forall(i in 1..n-1)(y[i] = abs(x[i] - x[i-1]));

solve satisfy;

output ["x: " ++ show(x) ++ "\n" ++ "y: " ++ show(y) ++ "\n"];