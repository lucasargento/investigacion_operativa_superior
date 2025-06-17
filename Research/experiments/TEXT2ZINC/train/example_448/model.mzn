% Parameters
int: TotalItems; % Total number of items
array[1..TotalItems] of int: ItemValues; % Value of each item
array[1..TotalItems] of int: ItemWeights; % Weight of each item
int: MaxKnapsackWeight; % Maximum weight capacity of the knapsack

% Decision Variables
array[1..TotalItems] of var 0..1: InKnapsack; % Binary variable indicating whether an item is in the knapsack

% Objective
% Maximize the total value of the items in the knapsack
var int: TotalValue = sum(i in 1..TotalItems) (InKnapsack[i] * ItemValues[i]);
maximize TotalValue;

% Constraints
% The total weight of the items in the knapsack should not exceed its weight capacity
constraint sum(i in 1..TotalItems) (InKnapsack[i] * ItemWeights[i]) <= MaxKnapsackWeight;

% Output
output ["Total Value: ", show(TotalValue), "\nItems in Knapsack: ", show(InKnapsack)];