% Parameters
int: goal_young;
int: goal_old;
int: goal_unique_young;
int: goal_unique_old;
array[1..A] of int: young_clicks;
array[1..A] of int: old_clicks;
array[1..A] of int: costs;
array[1..A] of int: max_clicks;
array[1..A] of int: unique_clicks;

% Decision Variables
array[1..A] of var 0..max_clicks[i]: clicks; % Number of clicks purchased for each ad type
var int: total_cost; % Total cost of the ad campaign

% Objective
minimize total_cost;

% Constraints
constraint total_cost = sum(i in 1..A)(clicks[i] * costs[i]);

% Total clicks from young and old individuals should meet the goals
constraint sum(i in 1..A)(clicks[i] * young_clicks[i]) >= goal_young;
constraint sum(i in 1..A)(clicks[i] * old_clicks[i]) >= goal_old;

% Total unique clicks from young and old individuals should meet the goals
constraint sum(i in 1..A)(clicks[i] * unique_clicks[i] * young_clicks[i]) >= goal_unique_young;
constraint sum(i in 1..A)(clicks[i] * unique_clicks[i] * old_clicks[i]) >= goal_unique_old;

% The number of clicks purchased should not exceed the maximum limit
constraint forall(i in 1..A)(clicks[i] <= max_clicks[i]);