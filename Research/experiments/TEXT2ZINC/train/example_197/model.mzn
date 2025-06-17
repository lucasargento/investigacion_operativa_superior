% Parameters
int: num_products = 7; % Number of products
int: num_months = 6; % Number of months
int: num_machines = 5; % Number of machines
array[1..num_machines] of int: num_machines_per_type = [4, 2, 3, 1, 1]; % Number of machines per type
array[1..num_products] of int: profit = [10, 6, 8, 4, 11, 9, 3]; % Profit per product
array[1..num_products, 1..num_machines] of float: time = [|0.5, 0.1, 0.2, 0.05, 0.0
                                                            |0.7, 0.2, 0.0, 0.03, 0.0
                                                            |0.0, 0.0, 0.8, 0.0, 0.01
                                                            |0.0, 0.3, 0.0, 0.07, 0.0
                                                            |0.3, 0.0, 0.0, 0.1, 0.05
                                                            |0.5, 0.0, 0.6, 0.08, 0.05|]; % Time per product per machine
array[1..num_machines] of int: down = [|0, 1, 1, 1, 1|]; % Downtime per machine
array[1..num_products, 1..num_months] of int: limit = [|500, 600, 300, 200, 0, 500
                                                        |1000, 500, 600, 300, 100, 500
                                                        |300, 200, 0, 400, 500, 100
                                                        |300, 0, 0, 500, 100, 300
                                                        |800, 400, 500, 200, 1000, 1100
                                                        |200, 300, 400, 0, 300, 500
                                                        |100, 150, 100, 100, 0, 60|]; % Limit per product per month
float: store_price = 0.5; % Storage price per product
int: keep_quantity = 100; % Quantity to keep in store
float: n_workhours = 8.0; % Number of work hours per day

% Variables
array[1..num_products, 1..num_months] of var 0..1000: sell; % Selling quantity per product per month
array[1..num_products, 1..num_months] of var 0..1000: manufacture; % Manufacturing quantity per product per month
array[1..num_products, 1..num_months] of var 0..1000: storage; % Storage quantity per product per month
array[1..num_machines, 1..num_months] of var 0..num_machines_per_type[1..num_machines]: maintain; % Maintenance quantity per machine per month

% Constraints
constraint forall(i in 1..num_months, k in 1..num_products) (
    sell[k, i] <= limit[k, i] % Selling limit
);

constraint forall(i in 1..num_months, k in 1..num_products) (
    manufacture[k, i] + if i > 1 then storage[k, i-1] else 0 endif = sell[k, i] + storage[k, i] % Manufacturing and storage balance
);

constraint forall(i in 1..num_months, m in 1..num_machines) (
    sum(k in 1..num_products) (manufacture[k, i] * time[k, m]) <= n_workhours * 24 * (num_machines_per_type[m] - maintain[m, i]) % Work hours limit
);

constraint forall(i in 1..num_months, m in 1..num_machines) (
    maintain[m, i] <= num_machines_per_type[m] % Maintenance limit
);

constraint forall(i in 1..num_months, m in 1..num_machines) (
    if i <= down[m] then maintain[m, i] = num_machines_per_type[m] else maintain[m, i] = 0 endif % Downtime
);

constraint forall(k in 1..num_products) (
    storage[k, num_months] = keep_quantity % Keep quantity
);

% Objective
var int: total_profit = sum(i in 1..num_months, k in 1..num_products) (profit[k] * sell[k, i] - store_price * storage[k, i]);
solve maximize total_profit;

% Output
output [ "sell: " ++ show(sell) ++ "\n" ++ "manufacture: " ++ show(manufacture) ++ "\n" ++ "storage: " ++ show(storage) ++ "\n" ++ "maintain: " ++ show(maintain) ++ "\n" ++ "total_profit: " ++ show(total_profit) ++ "\n" ];