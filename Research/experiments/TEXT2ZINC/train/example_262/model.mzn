include "globals.mzn";

% Define the parameters
int: n; % The number of variables
int: k; % The number of values

% Define the decision variables
array[1..n] of var 1..k: x;

% Define the constraints
constraint forall(i in 1..n-1)(x[i] <= x[i+1]);

% Define the objective function
var int: obj = sum(i in 1..n)(x[i]);

% Define the optimization problem
solve maximize obj;

% Output the solution
output ["x = ", show(x), "\n", "obj = ", show(obj), "\n"];

% Define the data
n = 5;
k = 10;