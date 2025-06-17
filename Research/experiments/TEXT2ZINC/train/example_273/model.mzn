include "globals.mzn";

% Define the degree
int: n = 5;

% Define the variables
array[1..3*n] of var bool: vars;

% Define the clauses
array[1..2*n, 1..3] of var 1..3*n: clauses;

% Define the constraints
constraint forall(i in 1..2*n) (
    bool_clause([vars[clauses[i,j]] | j in 1..3], [true, true, true])
);

% Define the objective function
var int: obj = sum(i in 1..2*n) (
    sum(j in 1..3) (if vars[clauses[i,j]] then 1 else 0 endif)
);

% Define the optimization problem
solve maximize obj;

% Output the solution
output ["Degree: " ++ show(n) ++ "\n"];
output ["Variables: " ++ show(vars) ++ "\n"];
output ["Clauses: " ++ show(clauses) ++ "\n"];
output ["Objective: " ++ show(obj) ++ "\n"];