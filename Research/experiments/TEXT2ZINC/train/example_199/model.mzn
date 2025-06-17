% Parameters
int: T; % Number of time periods
array[1..T] of int: Demands; % Demand for each time period
array[1..T] of int: UnloadCosts; % Unloading cost for each time period
array[1..T] of int: UnloadCapacity; % Unloading capacity for each time period
int: HoldingCost; % Cost of holding a container
int: MaxContainer; % Maximum number of containers that can be held
int: InitContainer; % Initial number of containers
int: NumCranes; % Number of cranes
int: CraneCapacity; % Capacity of each crane
int: CraneCost; % Cost of each crane

% Decision Variables
array[1..T] of var 0..MaxContainer: Containers; % Number of containers in each time period
array[1..T] of var 0..UnloadCapacity[i]: Unload; % Number of containers unloaded in each time period
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes rented in each time period

% Constraints
constraint Containers[1] = InitContainer + Unload[1] - Demands[1];
constraint forall(i in 2..T) (
    Containers[i] = Containers[i-1] + Unload[i] - Demands[i]
);
constraint forall(i in 1..T) (
    Cranes[i] * CraneCapacity >= Demands[i]
);
constraint forall(i in 1..T) (
    Containers[i] <= MaxContainer
);

% Objective
var int: TotalCost = sum(i in 1..T) (Unload[i] * UnloadCosts[i] + Containers[i] * HoldingCost + Cranes[i] * CraneCost);
solve minimize TotalCost;

% Output
output ["containers_unloaded: ", show(Unload), "\n", "cranes_rented: ", show(Cranes), "\n", "total_cost: ", show(TotalCost)];