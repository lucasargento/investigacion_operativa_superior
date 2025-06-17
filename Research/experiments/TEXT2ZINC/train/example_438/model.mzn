% Parameters
int: ProductNum; % Number of products
array[1..ProductNum] of int: ProductionRate; % Production rate of each product
array[1..ProductNum] of int: ProfitPerTon; % Profit per ton for each product
array[1..ProductNum] of int: MinimumSale; % Minimum sale limit for each product
array[1..ProductNum] of int: MaximumSale; % Maximum sale limit for each product
int: AvailableHours; % Available hours in a week

% Decision Variables
array[1..ProductNum] of var MinimumSale[1]..MaximumSale[ProductNum]: TonsProduced; % Tons of each product to be produced

% Objective
var int: TotalProfit = sum(p in 1..ProductNum) (ProfitPerTon[p] * TonsProduced[p]); % Total profit from selling all products

% Constraints
constraint sum(p in 1..ProductNum) (TonsProduced[p] / ProductionRate[p]) <= AvailableHours; % Total hours used by all products may not exceed the available hours

% Solve
solve maximize TotalProfit;

% Output
output [ "Tons of product " ++ show(p) ++ " to be produced: " ++ show(TonsProduced[p]) ++ "\n" | p in 1..ProductNum ];