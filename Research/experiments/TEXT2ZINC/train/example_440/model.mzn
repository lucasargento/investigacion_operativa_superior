% Define parameters
int: OriginNum;
int: DestinationNum;
int: ProductNum;
array[1..OriginNum, 1..ProductNum] of int: Supply;
array[1..DestinationNum, 1..ProductNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Limit;
array[1..OriginNum, 1..DestinationNum, 1..ProductNum] of int: Cost;

% Define decision variables
array[1..OriginNum, 1..DestinationNum, 1..ProductNum] of var 0..max(Supply) + max(Demand): Shipment;

% Objective: Minimize total cost
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum, p in 1..ProductNum) (Cost[i,j,p] * Shipment[i,j,p]);
minimize TotalCost;

% Constraints
% Total amount of each product shipped from each origin equals its supply
constraint forall(i in 1..OriginNum, p in 1..ProductNum) (sum(j in 1..DestinationNum) (Shipment[i,j,p]) = Supply[i,p]);

% Total amount of each product shipped to each destination equals its demand
constraint forall(j in 1..DestinationNum, p in 1..ProductNum) (sum(i in 1..OriginNum) (Shipment[i,j,p]) = Demand[j,p]);

% Total amount of all products shipped from each origin to each destination does not exceed limit
constraint forall(i in 1..OriginNum, j in 1..DestinationNum) (sum(p in 1..ProductNum) (Shipment[i,j,p]) <= Limit[i,j]);

% Output
output ["Total Cost: ", show(TotalCost)];