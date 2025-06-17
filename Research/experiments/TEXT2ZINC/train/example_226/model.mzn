% Parameters
int: M; % Number of months
int: I; % Number of oils
array[1..M, 1..I] of int: buy_price; % Buying price of each oil in each month
int: sell_price; % Selling price of the final product
array[1..I] of bool: is_vegetable; % Whether each oil is vegetable or not
int: max_vegetable_refining_per_month; % Maximum vegetable oil refining capacity per month
int: max_non_vegetable_refining_per_month; % Maximum non-vegetable oil refining capacity per month
int: storage_size; % Maximum storage capacity for each oil
int: storage_cost; % Storage cost per ton per month
int: min_hardness; % Minimum hardness of the final product
int: max_hardness; % Maximum hardness of the final product
array[1..I] of float: hardness; % Hardness of each oil
int: init_amount; % Initial amount of each oil in storage
int: min_usage; % Minimum usage of each oil if it is used
array[1..I, 1..I] of bool: dependencies; % Dependency matrix of oils

% Decision Variables
array[1..M, 1..I] of var 0..storage_size: buy; % Amount of each oil to buy in each month
array[1..M, 1..I] of var 0..storage_size: refine; % Amount of each oil to refine in each month
array[1..M, 1..I] of var 0..storage_size: storage; % Amount of each oil in storage in each month

% Constraints
constraint forall(m in 1..M)(
  sum(i in 1..I)(refine[m, i]) <= sell_price % Total refined oil should not exceed selling price
);

constraint forall(m in 1..M)(
  sum(i in 1..I where is_vegetable[i])(refine[m, i]) <= max_vegetable_refining_per_month % Vegetable oil refining capacity
);

constraint forall(m in 1..M)(
  sum(i in 1..I where not is_vegetable[i])(refine[m, i]) <= max_non_vegetable_refining_per_month % Non-vegetable oil refining capacity
);

constraint forall(m in 1..M, i in 1..I)(
  storage[m, i] <= storage_size % Storage capacity for each oil
);

constraint forall(m in 1..M)(
  sum(i in 1..I)(hardness[i] * refine[m, i]) / sum(i in 1..I)(refine[m, i]) >= min_hardness % Minimum hardness of final product
);

constraint forall(m in 1..M)(
  sum(i in 1..I)(hardness[i] * refine[m, i]) / sum(i in 1..I)(refine[m, i]) <= max_hardness % Maximum hardness of final product
);

constraint forall(m in 1..M, i in 1..I)(
  if refine[m, i] > 0 then refine[m, i] >= min_usage else true endif % Minimum usage of each oil if it is used
);

constraint forall(m in 1..M, i in 1..I, j in 1..I)(
  if dependencies[i, j] then refine[m, i] <= refine[m, j] else true endif % Dependency constraints
);

% Objective
var int: profit = sum(m in 1..M, i in 1..I)(sell_price * refine[m, i] - buy_price[m, i] * buy[m, i] - storage_cost * storage[m, i]);
solve maximize profit;