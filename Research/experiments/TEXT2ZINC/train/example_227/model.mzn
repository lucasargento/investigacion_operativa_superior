% Parameters
int: O; % Number of options
int: P; % Number of price points
int: L; % Number of processes
array[1..O] of float: Allocated; % Allocated resources for each option
array[1..P] of float: Price; % Price at each price point
array[1..L, 1..O] of float: Input; % Input required for each option in each process
array[1..L, 1..P] of float: Output; % Output produced for each price point in each process
array[1..L] of float: Cost; % Cost for each process

% Variables
array[1..L] of var 0.0..1000000.0: Execute; % Number of times each process is executed
var 0.0..1000000000.0: Revenue; % Total revenue

% Constraints
constraint forall(i in 1..O)(
    sum(l in 1..L)(Input[l,i]*Execute[l]) <= Allocated[i]
);

constraint forall(l in 1..L)(
    sum(p in 1..P)(Output[l,p]*Price[p]) >= Cost[l]*Execute[l]
);

% Objective
var float: totalRevenue = sum(l in 1..L, p in 1..P)(Output[l,p]*Price[p]*Execute[l]) - sum(l in 1..L)(Cost[l]*Execute[l]);
constraint Revenue = totalRevenue;

% Solve
solve maximize Revenue;

% Output
output ["revenue: ", show(Revenue), "\nexecute: ", show(Execute)];