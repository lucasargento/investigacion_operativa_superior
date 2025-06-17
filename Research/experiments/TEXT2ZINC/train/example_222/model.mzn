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
int: budget;

% Decision Variables
array[1..A] of var 0..max_clicks[i]: clicks;
var 0..sum(max_clicks): total_unique_clicks;

% Constraints
constraint forall(i in 1..A) (
    clicks[i] * costs[i] <= budget
);

constraint sum(i in 1..A) (clicks[i] * young_clicks[i]) >= goal_young;
constraint sum(i in 1..A) (clicks[i] * old_clicks[i]) >= goal_old;
constraint sum(i in 1..A) (clicks[i] * unique_clicks[i]) = total_unique_clicks;

constraint total_unique_clicks >= goal_unique_young + goal_unique_old;

% Objective
solve maximize total_unique_clicks;

% Output
output ["clicks: ", show(clicks), "\n", "total_unique_clicks: ", show(total_unique_clicks)];