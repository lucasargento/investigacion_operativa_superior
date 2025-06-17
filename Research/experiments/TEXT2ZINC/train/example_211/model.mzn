% Parameters
int: C; % Capacity of the knapsack
array[1..K] of int: value; % Value of each item
array[1..K] of int: size; % Size of each item

% Decision Variables
array[1..K] of var 0..1: isincluded; % Binary variable indicating whether each item is included

% Constraints
constraint sum(i in 1..K)(size[i]*isincluded[i]) <= C; % Total size of included items should not exceed the capacity

% Objective
var int: total_value = sum(i in 1..K)(value[i]*isincluded[i]); % Total value of included items
solve maximize total_value;

% Output
output ["isincluded: ", show(isincluded)];