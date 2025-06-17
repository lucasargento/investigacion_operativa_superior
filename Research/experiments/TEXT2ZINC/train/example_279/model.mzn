include "globals.mzn";

% Define the integer 'n'
var 1..100: n;

% Define the objective function
var int: obj = n;

% The objective is to minimize the value of 'n'
solve minimize obj;

output ["n = ", show(n), "\n"];