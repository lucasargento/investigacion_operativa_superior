% Parameters
int: T; % Number of days in a week
int: Period; % Number of days a nurse works in a row
array[1..T] of int: Demand; % Demand for nurses for each day

% Decision Variables
array[1..T] of var 0..sum(Demand): start; % Number of nurses that start their period on each day
var 0..sum(Demand): total; % Total number of nurses hired

% Constraints
constraint total = sum(start); % Total number of nurses is the sum of all starting nurses

% For each day, the number of working nurses should meet the demand
constraint forall(j in 1..T) (
    sum(i in max(1, j - Period + 1)..j) (start[(i-1) mod T + 1]) >= Demand[j]
);

% Objective
solve minimize total;

% Output
output ["start: ", show(start), "\n", "total: ", show(total)];