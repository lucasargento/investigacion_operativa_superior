% Parameters
int: n_products; % Number of products
int: n_machines; % Number of machines
int: n_months; % Number of months
array[1..n_products] of int: profit; % Profit for each product
array[1..n_products, 1..n_machines] of float: time; % Time to manufacture each product on each machine
array[1..n_months, 1..n_machines] of int: maintain; % Maintenance time for each machine in each month
array[1..n_products, 1..n_months] of int: limit; % Limit for storing each product in each month
float: store_price; % Price for storing products
int: keep_quantity; % Quantity to keep for each product
float: n_workhours; % Number of working hours

% Variables
array[1..n_products, 1..n_months] of var 0..limit: sell; % Selling quantity for each product in each month
array[1..n_products, 1..n_months] of var 0..limit: manufacture; % Manufacturing quantity for each product in each month
array[1..n_products, 1..n_months] of var 0..limit: storage; % Storage quantity for each product in each month

% Constraints
constraint forall(i in 1..n_months, m in 1..n_machines)(
    sum(k in 1..n_products)(time[k, m] * manufacture[k, i]) <= n_workhours * (24 - maintain[i, m])
);

constraint forall(i in 1..n_months, k in 1..n_products)(
    if i = 1 then
        sell[k, i] + storage[k, i] = manufacture[k, i]
    else
        sell[k, i] + storage[k, i] = manufacture[k, i] + storage[k, i-1]
    endif
);

constraint forall(i in 1..n_months, k in 1..n_products)(
    sell[k, i] <= limit[k, i]
);

constraint forall(k in 1..n_products)(
    storage[k, n_months] = keep_quantity
);

% Objective
var float: total_profit = sum(i in 1..n_months, k in 1..n_products)(profit[k] * sell[k, i] - store_price * storage[k, i]);
solve maximize total_profit;

% Output
output ["sell: ", show(sell), "\n", "manufacture: ", show(manufacture), "\n", "storage: ", show(storage)];