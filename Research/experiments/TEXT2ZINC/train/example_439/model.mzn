% Parameters
int: NumberOfFacilities;
int: NumberOfCustomers;
array[1..NumberOfFacilities] of int: FacilityFixedCost;
array[1..NumberOfFacilities, 1..NumberOfCustomers] of int: FacilityToCustomerTransportCost;
array[1..NumberOfFacilities] of int: FacilityCapacity;
array[1..NumberOfCustomers] of int: CustomerDemand;

% Decision Variables
array[1..NumberOfFacilities, 1..NumberOfCustomers] of var 0..1: x; % x[i,j] = 1 if facility i serves customer j
array[1..NumberOfFacilities] of var 0..1: y; % y[i] = 1 if facility i is open

% Constraints
% Each customer is served by exactly one facility
constraint forall(j in 1..NumberOfCustomers) (
    sum(i in 1..NumberOfFacilities) (x[i,j]) = 1
);

% Facility capacity constraints
constraint forall(i in 1..NumberOfFacilities) (
    sum(j in 1..NumberOfCustomers) (x[i,j] * CustomerDemand[j]) <= FacilityCapacity[i] * y[i]
);

% If a facility is not open, it cannot serve any customers
constraint forall(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (
    x[i,j] <= y[i]
);

% Objective Function: Minimize total cost
var int: total_cost = sum(i in 1..NumberOfFacilities) (y[i] * FacilityFixedCost[i]) + sum(i in 1..NumberOfFacilities, j in 1..NumberOfCustomers) (x[i,j] * FacilityToCustomerTransportCost[i,j]);
solve minimize total_cost;

% Output
output [ "Total Cost: " ++ show(total_cost) ++ "\n" ];