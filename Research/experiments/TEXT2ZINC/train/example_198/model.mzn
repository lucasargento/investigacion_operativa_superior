% Define parameters
int: A; % Number of alloys
int: S; % Number of steel types
array[1..A] of int: available; % Available amount of each alloy
array[1..A] of float: carbon; % Carbon content of each alloy
array[1..A] of float: nickel; % Nickel content of each alloy
array[1..A] of int: alloy_prices; % Price of each alloy
array[1..S] of int: steel_prices; % Price of each steel type
array[1..S] of float: carbon_min; % Minimum required carbon content for each steel type
array[1..S] of float: nickel_max; % Maximum allowed nickel content for each steel type

% Define decision variables
array[1..A, 1..S] of var 0..max(available): alloy_use; % Amount of each alloy used in each type of steel
array[1..S] of var 0..sum(available): total_steel; % Total amount of each steel type produced

% Define objective function
var int: total_profit = sum(s in 1..S)(steel_prices[s]*total_steel[s]) - sum(a in 1..A, s in 1..S)(alloy_prices[a]*alloy_use[a,s]);

% Define constraints
constraint forall(a in 1..A)(sum(s in 1..S)(alloy_use[a,s]) <= available[a]); % Do not use more alloy than available
constraint forall(s in 1..S)(sum(a in 1..A)(alloy_use[a,s]*carbon[a]) >= carbon_min[s]*total_steel[s]); % Meet minimum carbon content
constraint forall(s in 1..S)(sum(a in 1..A)(alloy_use[a,s]*nickel[a]) <= nickel_max[s]*total_steel[s]); % Do not exceed maximum nickel content
constraint forall(s in 1..S)(sum(a in 1..A)(alloy_use[a,s]) = total_steel[s]); % Total steel produced is the sum of all alloys used
constraint forall(s in 1..S)(alloy_use[1,s] <= 0.4*total_steel[s]); % At most 40% of alloy 1 can be used in any steel type

% Maximize profit
solve maximize total_profit;

% Output
output ["alloy_use: ", show(alloy_use), "\n", "total_steel: ", show(total_steel), "\n", "total_profit: ", show(total_profit)];