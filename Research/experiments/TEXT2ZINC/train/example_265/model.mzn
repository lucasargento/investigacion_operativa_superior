include "globals.mzn";

% Size of the sequence
int: n = 10;

% Sequence of integers
array[0..n-1] of var 0..n-1: x;

% Cardinality constraints
constraint forall(i in 0..n-1)(count(x, i, x[i]));

% Sum constraints
constraint sum(x) = n;

solve satisfy;

output ["Magic Sequence: "] ++ [show(x[i]) | i in 0..n-1];