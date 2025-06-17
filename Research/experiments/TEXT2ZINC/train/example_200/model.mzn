% Parameters
int: NumTerminals; % Number of terminals
int: NumDestinations; % Number of destinations
array[1..NumTerminals, 1..NumDestinations] of int: Cost; % Cost matrix
array[1..NumTerminals] of int: Supply; % Supply at each terminal
array[1..NumDestinations] of int: Demand; % Demand at each destination

% Decision Variables
array[1..NumTerminals, 1..NumDestinations] of var 0..max(Supply)+max(Demand): Transport; % Amount of soybeans transported from each terminal to each destination

% Objective
var int: total_cost; % Total transportation cost

% Constraints
constraint total_cost = sum(i in 1..NumTerminals, j in 1..NumDestinations)(Cost[i,j]*Transport[i,j]); % Total cost is the sum of the cost of transporting each unit of soybeans
constraint forall(i in 1..NumTerminals)(sum(j in 1..NumDestinations)(Transport[i,j]) <= Supply[i]); % The total amount of soybeans transported from each terminal cannot exceed its supply
constraint forall(j in 1..NumDestinations)(sum(i in 1..NumTerminals)(Transport[i,j]) >= Demand[j]); % The total amount of soybeans transported to each destination must meet its demand

% Solve
solve minimize total_cost;

% Output
output [ "distribution: " ++ show(Transport) ++ "\n" ++ "total_cost: " ++ show(total_cost) ++ "\n" ];