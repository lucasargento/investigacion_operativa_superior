% Number of origins and destinations
int: NumberOfOrigins;
int: NumberOfDestinations;

% Supply of each origin and demand of each destination
array[1..NumberOfOrigins] of int: SupplyOfOrigin;
array[1..NumberOfDestinations] of int: DemandOfDestination;

% Cost of transporting from an origin to a destination
array[1..NumberOfOrigins, 1..NumberOfDestinations] of int: CostPerUnit;

% Decision variable: amount transported from each origin to each destination
array[1..NumberOfOrigins, 1..NumberOfDestinations] of var 0..max(SupplyOfOrigin): Transport;

% Objective: Minimize the total cost of transportation
minimize sum(i in 1..NumberOfOrigins, j in 1..NumberOfDestinations) (Transport[i,j] * CostPerUnit[i,j]);

% Constraints: The total supply from each origin and the total demand at each destination must be met
constraint forall(i in 1..NumberOfOrigins) (sum(j in 1..NumberOfDestinations) (Transport[i,j]) = SupplyOfOrigin[i]);
constraint forall(j in 1..NumberOfDestinations) (sum(i in 1..NumberOfOrigins) (Transport[i,j]) = DemandOfDestination[j]);

solve satisfy;