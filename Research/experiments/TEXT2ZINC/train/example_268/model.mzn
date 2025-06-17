include "globals.mzn";

% Define the variables
var int: n;
var int: c;

% Define the constraint
constraint n + c = 10;

% Define the objective function
solve maximize n;

% Output the solution
output ["n = ", show(n), "\nc = ", show(c)];