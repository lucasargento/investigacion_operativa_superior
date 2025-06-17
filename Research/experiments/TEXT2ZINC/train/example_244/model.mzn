% Parameters
int: N; % Number of months
array[1..N] of float: demand; % Demand for each month
float: max_regular_amount; % Maximum production amount under regular conditions
float: cost_regular; % Cost of regular production per unit
float: cost_overtime; % Cost of production under overtime conditions per unit
float: store_cost; % Cost to store one unit of product

% Decision Variables
array[1..N] of var 0.0..max_regular_amount: reg_quant; % Quantity of products produced using regular production in each month
array[1..N] of var 0.0..max_regular_amount: over_quant; % Quantity of products produced using overtime production in each month
array[1..N] of var 0.0..max_regular_amount: store_quant; % Quantity of products stored in each month

% Constraints
constraint forall(i in 1..N) (
    if i = 1 then
        reg_quant[i] + over_quant[i] - demand[i] = store_quant[i]
    else
        reg_quant[i] + over_quant[i] + store_quant[i-1] - demand[i] = store_quant[i]
    endif
);

% Objective
var float: total_cost;
constraint total_cost = sum(i in 1..N) (cost_regular * reg_quant[i] + cost_overtime * over_quant[i] + store_cost * store_quant[i]);
solve minimize total_cost;

% Output
output ["reg_quant: ", show(reg_quant), "\n", "over_quant: ", show(over_quant)];