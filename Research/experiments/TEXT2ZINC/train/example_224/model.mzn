% Parameters
int: P; % Number of power plants
int: C; % Number of cities
array[1..P] of int: supply; % Supply capacity of each power plant
array[1..C] of int: demand; % Demand of each city
array[1..P, 1..C] of int: transmission_costs; % Transmission costs between power plants and cities

% Decision Variables
array[1..P, 1..C] of var 0..max(supply): send; % Amount of electricity each power plant sends to each city

% Objective
var int: total_cost; % Total transmission cost

% Constraints
constraint forall(p in 1..P)(sum(c in 1..C)(send[p,c]) <= supply[p]); % Supply capacity constraint
constraint forall(c in 1..C)(sum(p in 1..P)(send[p,c]) = demand[c]); % Demand constraint

% Objective function
constraint total_cost = sum(p in 1..P, c in 1..C)(send[p,c] * transmission_costs[p,c]);

% Solve
solve minimize total_cost;

% Output
output ["send = ", show2d(send), "\n", "total_cost = ", show(total_cost)];