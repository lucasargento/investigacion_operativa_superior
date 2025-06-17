% Parameters
int: T; % Number of periods
array[1..T] of int: Deliver; % Units to be delivered each period
int: StorageCost; % Cost per unit per period for storage
int: SwitchCost; % Cost for changing production level

% Decision Variables
array[1..T] of var 0..sum(Deliver): x; % Units produced each period
array[1..T] of var 0..sum(Deliver): inventory; % Units in inventory each period

% Objective
var int: cost; % Total cost

% Constraints
constraint inventory[1] = x[1] - Deliver[1];
constraint forall(i in 2..T) (
    inventory[i] = inventory[i-1] + x[i] - Deliver[i]
);
constraint forall(i in 2..T) (
    cost >= SwitchCost * abs(x[i] - x[i-1])
);
constraint cost >= sum(i in 1..T) (StorageCost * inventory[i]);

% Objective
solve minimize cost;

% Output
output ["x: ", show(x), "\ncost: ", show(cost)];