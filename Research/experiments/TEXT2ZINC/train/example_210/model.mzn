% Parameters
int: K; % Number of industries
int: T; % Number of years
array[1..K, 1..K] of float: inputone;
array[1..K] of float: manpowerone;
array[1..K, 1..K] of float: inputtwo;
array[1..K] of float: manpowertwo;
array[1..K] of int: stock;
array[1..K] of int: capacity;
float: manpower_limit;

% Decision Variables
array[1..K, 1..T] of var 0..capacity[K]: produce;
array[1..K, 1..T] of var 0..capacity[K]: buildcapa;
array[1..K, 1..T] of var 0..capacity[K]: stockhold;

% Constraints
constraint forall(k in 1..K, t in 1..T) (
    produce[k, t] + buildcapa[k, t] + stockhold[k, t] <= capacity[k]
);

constraint forall(k in 1..K, t in 2..T) (
    produce[k, t] + buildcapa[k, t] + stockhold[k, t] <= produce[k, t-1] + stock[k]
);

constraint forall(k in 1..K, t in 1..T) (
    sum(j in 1..K) (inputone[k, j] * produce[j, t]) + manpowerone[k] <= manpower_limit
);

constraint forall(k in 1..K, t in 1..T) (
    sum(j in 1..K) (inputtwo[k, j] * buildcapa[j, t]) + manpowertwo[k] <= manpower_limit
);

% Objective
var int: total_production = sum(k in 1..K) (produce[k, T-1] + produce[k, T]);
solve maximize total_production;

% Output
output [ "produce: " ++ show(produce) ++ "\n" ++
         "buildcapa: " ++ show(buildcapa) ++ "\n" ++
         "stockhold: " ++ show(stockhold) ++ "\n" ];