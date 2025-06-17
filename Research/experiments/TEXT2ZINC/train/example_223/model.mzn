% Define parameters
int: num_foods; % Number of available foods
int: num_nutrients; % Number of nutrients

array[1..num_foods] of int: price; % Price of each food
array[1..num_nutrients] of int: demand; % Demand for each nutrient
array[1..num_foods, 1..num_nutrients] of int: nutrition; % Nutrition matrix

% Define decision variables
array[1..num_foods] of var 0..100: quantity; % Quantity of each food to purchase

% Define objective function
var int: total_price = sum(i in 1..num_foods)(price[i]*quantity[i]);
minimize total_price;

% Define constraints
constraint forall(i in 1..num_nutrients)(
  sum(j in 1..num_foods)(nutrition[j,i]*quantity[j]) >= demand[i]
);