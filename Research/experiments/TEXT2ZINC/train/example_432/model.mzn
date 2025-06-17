% Parameters
int: TotalAircraft;
int: TotalRoutes;
array[1..TotalAircraft] of int: Availability;
array[1..TotalRoutes] of int: Demand;
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;

% Decision Variables
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assign;

% Objective: Minimize total cost
var int: TotalCost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes)(Assign[i,j]*Costs[i,j]);
minimize TotalCost;

% Constraints
% Each aircraft can be assigned to a maximum of its availability
constraint forall(i in 1..TotalAircraft)(sum(j in 1..TotalRoutes)(Assign[i,j]) <= Availability[i]);

% The total capacity assigned to each route must meet its demand
constraint forall(j in 1..TotalRoutes)(sum(i in 1..TotalAircraft)(Assign[i,j]*Capacity[i,j]) >= Demand[j]);

% An aircraft can only be assigned to a route if it has the capacity to service it
constraint forall(i in 1..TotalAircraft, j in 1..TotalRoutes)(Assign[i,j] <= Capacity[i,j]);

solve satisfy;