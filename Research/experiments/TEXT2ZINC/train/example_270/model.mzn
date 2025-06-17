include "alldifferent.mzn";

% Define the number of pigeons
int: n = 5;

% Define the pigeon holes
array[1..n+1] of var 1..n: pigeon_holes;

% All pigeon holes must be different
constraint alldifferent(pigeon_holes);

solve satisfy;

output ["Pigeon holes: " ++ show(pigeon_holes)];