include "globals.mzn";

% Define the size of the alphabet and the order of the sequence
int: b = 3; % size of the alphabet
int: n = 2; % order of the sequence

% Define the sequence
array[1..b^n] of var 1..b: sequence;

% Define the constraints
constraint alldifferent(sequence);
constraint forall(i in 1..b)(sum(j in sequence)(j = i) = n);
constraint sum(sequence) = b * n;

% Solve the problem
solve satisfy;

% Output the solution
output ["Sequence: " ++ show(sequence)];