% Parameters
int: M; % Number of goods
int: N; % Number of raw materials
array[1..N] of int: Available; % Available amount of each raw material
array[1..M, 1..N] of int: Requirements; % Requirements of each raw material for each good
array[1..M] of int: Prices; % Price of each good

% Decision Variables
array[1..M] of var 0..sum(Available): amount; % Amount of each good to produce

% Objective
maximize sum(j in 1..M)(amount[j] * Prices[j]);

% Constraints
constraint forall(i in 1..N)(
    sum(j in 1..M)(Requirements[j, i] * amount[j]) <= Available[i]
);