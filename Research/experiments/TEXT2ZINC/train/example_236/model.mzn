% Parameters
int: M; % Number of months
int: I; % Number of items
array[1..M, 1..I] of int: BuyPrice; % Buy price of item i in month m
int: SellPrice; % Sell price of all items
array[1..I] of bool: IsVegetable; % Whether item i is a vegetable
int: MaxVegetableRefiningPerMonth; % Maximum vegetable refining per month
int: MaxNonVegetableRefiningPerMonth; % Maximum non-vegetable refining per month
int: StorageSize; % Storage size
int: StorageCost; % Storage cost per month
float: MinHardness; % Minimum hardness of the product
float: MaxHardness; % Maximum hardness of the product
array[1..I] of float: Hardness; % Hardness of item i
int: InitialAmount; % Initial amount of items in storage

% Decision Variables
array[1..M, 1..I] of var 0..StorageSize: buy; % Amount of item i to buy in month m
array[1..M, 1..I] of var 0..StorageSize: refine; % Amount of item i to refine in month m
array[1..M, 1..I] of var 0..StorageSize: storage; % Amount of item i to store in month m

% Objective: Maximize profit
var int: profit;
constraint profit = sum(m in 1..M, i in 1..I) ((SellPrice - BuyPrice[m,i] - StorageCost) * refine[m,i]) - sum(m in 1..M, i in 1..I) (BuyPrice[m,i] * buy[m,i]);
solve maximize profit;

% Constraints
% Initial and final storage amounts
constraint forall(i in 1..I) (storage[1,i] = InitialAmount);
constraint forall(i in 1..I) (storage[M,i] = InitialAmount);

% Storage capacity
constraint forall(m in 1..M, i in 1..I) (storage[m,i] <= StorageSize);

% Refining capacity
constraint forall(m in 1..M) (sum(i in 1..I where IsVegetable[i]) (refine[m,i]) <= MaxVegetableRefiningPerMonth);
constraint forall(m in 1..M) (sum(i in 1..I where not IsVegetable[i]) (refine[m,i]) <= MaxNonVegetableRefiningPerMonth);

% Hardness range
constraint forall(m in 1..M) (sum(i in 1..I) (Hardness[i] * refine[m,i]) / sum(i in 1..I) (refine[m,i]) >= MinHardness);
constraint forall(m in 1..M) (sum(i in 1..I) (Hardness[i] * refine[m,i]) / sum(i in 1..I) (refine[m,i]) <= MaxHardness);

% Storage update
constraint forall(m in 1..M-1, i in 1..I) (storage[m+1,i] = storage[m,i] + buy[m,i] - refine[m,i]);