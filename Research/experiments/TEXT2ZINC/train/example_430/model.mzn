% Parameters
int: NumberOfLocations;
int: NumberOfCustomers;
array[1..NumberOfCustomers] of int: CustomerDemand;
array[1..NumberOfLocations, 1..NumberOfCustomers] of int: ServiceAllocationCost;
array[1..NumberOfLocations] of int: WarehouseCapacity;
array[1..NumberOfLocations] of int: MinimumDemandFromWarehouse;
int: MinimumOpenWarehouses;
int: MaximumOpenWarehouses;
array[1..NumberOfLocations] of int: WarehouseFixedCost;

% Decision Variables
array[1..NumberOfLocations] of var 0..1: WarehouseOpen; % 1 if warehouse is open, 0 otherwise
array[1..NumberOfLocations, 1..NumberOfCustomers] of var 0..1: ServiceAllocation; % 1 if customer is served by warehouse, 0 otherwise

% Constraints
constraint sum(WarehouseOpen) >= MinimumOpenWarehouses;
constraint sum(WarehouseOpen) <= MaximumOpenWarehouses;

% Each customer is served by exactly one warehouse
constraint forall(i in 1..NumberOfCustomers) (
    sum(j in 1..NumberOfLocations) (ServiceAllocation[j, i]) = 1
);

% If a warehouse is open, it serves at least the minimum demand
constraint forall(i in 1..NumberOfLocations) (
    WarehouseOpen[i] * MinimumDemandFromWarehouse[i] <= sum(j in 1..NumberOfCustomers) (ServiceAllocation[i, j] * CustomerDemand[j])
);

% A warehouse cannot serve more than its capacity
constraint forall(i in 1..NumberOfLocations) (
    sum(j in 1..NumberOfCustomers) (ServiceAllocation[i, j] * CustomerDemand[j]) <= WarehouseCapacity[i]
);

% If a warehouse is closed, it cannot serve any customers
constraint forall(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (
    ServiceAllocation[i, j] <= WarehouseOpen[i]
);

% Objective Function: Minimize total cost
var int: TotalCost = sum(i in 1..NumberOfLocations) (WarehouseOpen[i] * WarehouseFixedCost[i]) + sum(i in 1..NumberOfLocations, j in 1..NumberOfCustomers) (ServiceAllocation[i, j] * ServiceAllocationCost[i, j]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"];