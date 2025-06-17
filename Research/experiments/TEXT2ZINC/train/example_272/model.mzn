include "globals.mzn";

% Define the number of variables and the size of the domain
int: n = 5;
int: d = 3;

% Define the variant type
string: variant = "primary";

% Define the variables
array[1..n] of var 1..d: vars;

% Define the constraints
constraint if variant = "primary" then alldifferent(vars) else forall(i in 1..n-1)(vars[i] = vars[i+1]) endif;

% Define the objective function
var int: obj = sum(vars);

% Solve the problem
solve minimize obj;

% Output the solution
output ["Variables: " ++ show(vars) ++ "\nObjective: " ++ show(obj)];