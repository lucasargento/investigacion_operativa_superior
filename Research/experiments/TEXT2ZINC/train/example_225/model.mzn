% Parameters
int: K; % Number of spare parts
int: S; % Number of machines
array[1..K, 1..S] of int: time; % Time taken to make each spare part on each machine
array[1..K] of int: profit; % Profit obtained from making each spare part
array[1..S] of int: capacity; % Capacity of each machine

% Decision Variables
array[1..K] of var 0..capacity[S]: quantity; % Quantity of each spare part to be made

% Objective
maximize sum(k in 1..K)(profit[k]*quantity[k]);

% Constraints
constraint forall(s in 1..S)(
    sum(k in 1..K)(time[k,s]*quantity[k]) <= capacity[s]
);