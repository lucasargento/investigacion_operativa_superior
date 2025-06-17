% Parameters
int: K; % Number of departments
int: L; % Number of cities
array[1..K, 1..L] of int: benefit; % Benefit for each department at each city
array[1..K, 1..K] of float: communication; % Communication between departments
array[1..L, 1..L] of int: cost; % Cost of communication between cities

% Decision Variables
array[1..K, 1..L] of var 0..1: islocated; % Whether department k is located at city l

% Constraints
% Each department is located at exactly one city
constraint forall(k in 1..K)(sum(l in 1..L)(islocated[k, l]) = 1);

% No city can have more than three departments
constraint forall(l in 1..L)(sum(k in 1..K)(islocated[k, l]) <= 3);

% Objective Function
% Minimize the total cost of communication and relocation
var int: total_cost;
constraint total_cost = sum(k in 1..K, l in 1..L)(islocated[k, l] * (benefit[k, l] + sum(j in 1..K, m in 1..L)(islocated[j, m] * communication[k, j] * cost[l, m])));
solve minimize total_cost;

% Output
output ["islocated: ", show2dArray([ [islocated[k, l] | l in 1..L] | k in 1..K])];