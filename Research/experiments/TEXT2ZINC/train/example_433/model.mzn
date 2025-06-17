% Parameters
int: OriginNum;
int: DestinationNum;
array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

% Decision Variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply) : Transport;

% Constraints
% The total goods transported from each origin should not exceed its supply
constraint forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum) (Transport[i,j]) <= Supply[i]
);

% The total goods transported to each destination should meet its demand
constraint forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum) (Transport[i,j]) = Demand[j]
);

% Objective
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum) (Transport[i,j] * Cost[i,j]);
solve minimize TotalCost;

% Output
output [ "Transport[" ++ show(i) ++ "," ++ show(j) ++ "]=" ++ show(Transport[i,j]) ++ "\n" | i in 1..OriginNum, j in 1..DestinationNum ];