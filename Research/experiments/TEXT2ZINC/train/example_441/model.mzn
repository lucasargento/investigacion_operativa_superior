% Parameters
int: NumItems;
int: NumPeriods;
array[1..NumItems, 1..NumPeriods] of int: Demand;
array[1..NumPeriods] of int: TotalPeriodCapacity;
array[1..NumItems, 1..NumPeriods] of int: ItemCapacity;
array[1..NumItems] of int: HoldingCost;
array[1..NumItems] of int: BackorderCost;
array[1..NumItems] of int: FixedCost;
array[1..NumItems] of int: InitialStock;

% Decision Variables
array[1..NumItems, 1..NumPeriods] of var 0..TotalPeriodCapacity[NumPeriods]: Production;
array[1..NumItems, 1..NumPeriods] of var 0..TotalPeriodCapacity[NumPeriods]: Stock;
array[1..NumItems, 1..NumPeriods] of var 0..1: Order;

% Constraints
constraint forall(i in 1..NumItems, j in 1..NumPeriods) (
    if j = 1 then
        Stock[i,j] = InitialStock[i] + Production[i,j] - Demand[i,j]
    else
        Stock[i,j] = Stock[i,j-1] + Production[i,j] - Demand[i,j]
    endif
);

constraint forall(j in 1..NumPeriods) (
    sum(i in 1..NumItems) (Production[i,j]) <= TotalPeriodCapacity[j]
);

constraint forall(i in 1..NumItems, j in 1..NumPeriods) (
    Production[i,j] <= ItemCapacity[i,j] * Order[i,j]
);

% Objective Function
var int: TotalCost = sum(i in 1..NumItems, j in 1..NumPeriods) (
    HoldingCost[i] * max(0, Stock[i,j]) +
    BackorderCost[i] * max(0, -Stock[i,j]) +
    FixedCost[i] * Order[i,j]
);

solve minimize TotalCost;

% Output
output [ "Total Cost: " ++ show(TotalCost) ++ "\n" ];