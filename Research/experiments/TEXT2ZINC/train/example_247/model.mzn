% Parameters
int: T; % Number of years
array[1..T] of int: Demand; % Demand for each year
array[1..T] of int: OilCap; % Oil capacity for each year
int: CoalCost; % Cost per unit of coal capacity
int: NukeCost; % Cost per unit of nuclear capacity
int: MaxNuke; % Maximum nuclear capacity
int: CoalLife; % Lifetime of a coal plant
int: NukeLife; % Lifetime of a nuclear plant

% Decision Variables
array[1..T] of var 0..Demand[T]: CoalCapAdded; % Coal capacity added each year
array[1..T] of var 0..Demand[T]: NukeCapAdded; % Nuclear capacity added each year

% Total cost
var int: TotalCost;

% Constraints
constraint forall(t in 1..T)(
  % Total capacity must meet demand
  sum(i in max(1, t-CoalLife+1)..t)(CoalCapAdded[i]) +
  sum(i in max(1, t-NukeLife+1)..t)(NukeCapAdded[i]) + OilCap[t] >= Demand[t]
);

constraint forall(t in 1..T)(
  % Nuclear capacity must not exceed maximum
  sum(i in max(1, t-NukeLife+1)..t)(NukeCapAdded[i]) <= MaxNuke
);

% Objective
constraint TotalCost = sum(t in 1..T)(CoalCost * CoalCapAdded[t] + NukeCost * NukeCapAdded[t]);

% Minimize total cost
solve minimize TotalCost;

% Output
output ["{\"coal_cap_added\": [", join(", ", [show(CoalCapAdded[t]) | t in 1..T]), "], \"nuke_cap_added\": [", join(", ", [show(NukeCapAdded[t]) | t in 1..T]), "], \"total_cost\": ", show(TotalCost), "}"];