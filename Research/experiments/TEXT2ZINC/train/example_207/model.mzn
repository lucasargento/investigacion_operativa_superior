% Parameters
int: n_steel_quant; % Quantity of steel to produce
float: mn_percent; % Required manganese percentage
float: si_min; % Minimum silicon percentage
float: si_max; % Maximum silicon percentage
array[1..3] of float: contsi; % Silicon content in each stock
array[1..3] of float: contmn; % Manganese content in each stock
float: mang_price; % Price of manganese per ton
array[1..3] of int: cost; % Material cost for each stock
float: sell_price; % Selling price per ton of steel
float: melt_price; % Melting cost per ton

% Decision Variables
var 0..n_steel_quant: amount[1..3]; % Amount of each mineral to melt
var 0..n_steel_quant: num_mang; % Amount of manganese to add

% Constraints
constraint sum(amount) + num_mang = n_steel_quant; % Total steel produced
constraint sum([contsi[i]*amount[i] | i in 1..3]) >= si_min*n_steel_quant; % Minimum silicon content
constraint sum([contsi[i]*amount[i] | i in 1..3]) <= si_max*n_steel_quant; % Maximum silicon content
constraint sum([contmn[i]*amount[i] | i in 1..3]) + num_mang*mn_percent >= mn_percent*n_steel_quant; % Manganese content

% Objective Function
var float: profit = sell_price*n_steel_quant - (sum([cost[i]*amount[i] | i in 1..3]) + mang_price*num_mang + melt_price*sum(amount));
solve maximize profit;

% Output
output ["amount: ", show(amount), "\n", "num_mang: ", show(num_mang)];