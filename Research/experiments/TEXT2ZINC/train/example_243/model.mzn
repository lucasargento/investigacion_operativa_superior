% Parameters
int: capacity; % Maximum storage capacity
int: holding_cost; % Holding cost per unit per period
array[1..3] of int: price; % Selling price per period
array[1..3] of int: cost; % Buying cost per period

% Decision Variables
array[1..3] of var 0..capacity: buyquantity; % Quantity to buy per period
array[1..3] of var 0..capacity: sellquantity; % Quantity to sell per period
array[1..3] of var 0..capacity: stock; % Stock per period

% Constraints
constraint forall(i in 2..3)(stock[i] = stock[i-1] + buyquantity[i] - sellquantity[i]);
constraint stock[1] = buyquantity[1] - sellquantity[1];
constraint forall(i in 1..3)(stock[i] <= capacity);
constraint stock[3] = 0;

% Objective Function
var int: profit = sum(i in 1..3)(price[i]*sellquantity[i] - cost[i]*buyquantity[i] - holding_cost*stock[i]);
solve maximize profit;

% Output
output ["buyquantity: ", show(buyquantity), "\n", "sellquantity: ", show(sellquantity), "\n", "stock: ", show(stock)];