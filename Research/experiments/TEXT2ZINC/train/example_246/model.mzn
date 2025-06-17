% Parameters
int: regular_cost;
int: overtime_cost;
float: assembly_time;
int: material_cost;
int: selling_price;
int: holding_cost;
int: salvage_value;
array[1..4] of int: demand;
array[1..4] of int: regular_labor;
array[1..4] of int: overtime_labor;

% Variables
array[1..4] of var 0..regular_labor[i]: regular_used;
array[1..4] of var 0..overtime_labor[i]: overtime_used;
array[1..4] of var 0..demand[i]: regular_baskets;
array[1..4] of var 0..demand[i]: overtime_baskets;
array[1..4] of var 0..sum(i in 1..4)(regular_baskets[i] + overtime_baskets[i]): inventory;
var int: total_profit;

% Constraints
constraint forall(i in 1..4) (
    regular_used[i] <= regular_labor[i] / assembly_time
    /\ overtime_used[i] <= overtime_labor[i] / assembly_time
    /\ regular_baskets[i] + overtime_baskets[i] >= demand[i]
    /\ regular_baskets[i] <= regular_used[i] * assembly_time
    /\ overtime_baskets[i] <= overtime_used[i] * assembly_time
);

constraint forall(i in 2..4) (
    inventory[i] = inventory[i-1] + regular_baskets[i] + overtime_baskets[i] - demand[i]
);

constraint inventory[1] = regular_baskets[1] + overtime_baskets[1] - demand[1];

% Objective
solve maximize total_profit = sum(i in 1..4) (
    selling_price * (regular_baskets[i] + overtime_baskets[i])
    - regular_cost * regular_used[i]
    - overtime_cost * overtime_used[i]
    - material_cost * (regular_baskets[i] + overtime_baskets[i])
    - holding_cost * inventory[i]
) + salvage_value * inventory[4];