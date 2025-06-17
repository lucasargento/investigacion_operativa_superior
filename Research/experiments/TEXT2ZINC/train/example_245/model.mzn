% Define parameters
int: I; % Number of projects
int: J; % Number of consultants
int: K; % Maximum projects per consultant
array[1..J] of int: fixed_costs; % Fixed costs for each consultant
array[1..I, 1..J] of int: additional_costs; % Additional costs for assigning project i to consultant j

% Define decision variables
array[1..I, 1..J] of var 0..1: assignments; % Assignment of project i to consultant j
array[1..J] of var 0..1: consultant_hired; % Whether consultant j is hired

% Define constraints
constraint forall(j in 1..J) (
    sum(i in 1..I) (assignments[i,j]) <= K * consultant_hired[j]
);

% Define objective function
var int: total_cost = sum(j in 1..J) (fixed_costs[j] * consultant_hired[j]) + sum(i in 1..I, j in 1..J) (additional_costs[i,j] * assignments[i,j]);

% Minimize total cost
solve minimize total_cost;

% Output assignments and total cost
output ["assignments = ", show(assignments), "\n", "total_cost = ", show(total_cost)];