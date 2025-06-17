% Define parameters
int: N; % Number of raw materials
int: M; % Number of products
array[1..N] of int: available; % Available amount of each raw material
array[1..M, 1..N] of int: requirements; % Requirement of each raw material for each product
array[1..M] of int: prices; % Selling price of each product
array[1..M] of int: costs; % Production cost of each product
array[1..M] of int: demands; % Market demand of each product

% Define decision variables
array[1..M] of var 0..demands[i]: amount; % Amount of each product to produce

% Define objective
var int: total_profit = sum(i in 1..M)(amount[i] * (prices[i] - costs[i]));

% Define constraints
constraint forall(i in 1..N)(sum(j in 1..M)(requirements[j, i] * amount[j]) <= available[i]);

% Maximize total profit
solve maximize total_profit;

% Output
output ["amount: ", show(amount), "\n", "total_profit: ", show(total_profit)];