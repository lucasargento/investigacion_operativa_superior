include "globals.mzn";

% Define the variables
var 1..6: grandparents;
var 1..10: parents;
var 1..40: children;

% Define the constraints
constraint grandparents + parents + children = 20;
constraint 3*grandparents + 2*parents + 0.5*children = 20;

% Define the objective function
solve satisfy;

% Output the solution
output ["Number of grandparents: " ++ show(grandparents) ++ "\n" ++
        "Number of parents: " ++ show(parents) ++ "\n" ++
        "Number of children: " ++ show(children)];