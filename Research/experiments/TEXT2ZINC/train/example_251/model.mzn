% Define parameters
int: alloy_quant; % Total quantity of alloy to produce
array[1..M] of int: target; % Quantity of target components in the alloy
array[1..K, 1..M] of float: ratio; % Ratio of each component in each alloy
array[1..K] of float: price; % Price of each alloy

% Define decision variables
array[1..K] of var 0..alloy_quant: amount; % Amount of each alloy to buy

% Define constraints
constraint forall(m in 1..M) (
    sum(k in 1..K) (amount[k] * ratio[k,m]) >= target[m]
);

% Define objective function
var float: total_cost = sum(k in 1..K) (amount[k] * price[k]);

% Minimize the total cost
solve minimize total_cost;

% Output the solution
output ["amount: " ++ show(amount)];