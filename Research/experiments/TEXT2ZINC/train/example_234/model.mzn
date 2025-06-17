% Define parameters
int: T = 5; % Number of periods
int: K = 3; % Number of generator types
array[1..T] of int: demand; % Demand for each period
array[1..K] of int: num; % Number of each generator type
array[1..K] of int: minlevel; % Minimum level of each generator type
array[1..K] of int: maxlevel; % Maximum level of each generator type
array[1..K] of int: runcost; % Running cost of each generator type
array[1..K] of float: extracost; % Extra cost of each generator type
array[1..K] of int: startcost; % Start-up cost of each generator type

% Define decision variables
array[1..K, 1..T] of var 0..num: numon; % Number of generators of each type that are on in each period
array[1..K, 1..T] of var minlevel..maxlevel: level; % Level at which each generator type is operated in each period

% Define constraints
constraint forall(k in 1..K, t in 1..T) (
    minlevel[k]*numon[k,t] <= level[k,t] /\ level[k,t] <= maxlevel[k]*numon[k,t]
);
constraint forall(t in 1..T) (
    sum(k in 1..K) (level[k,t]) >= demand[t]
);

% Define objective function
var float: total_cost = sum(k in 1..K, t in 1..T) (
    runcost[k]*numon[k,t] + extracost[k]*(level[k,t] - minlevel[k]*numon[k,t]) + startcost[k]*(numon[k,t] > 0)
);

% Minimize total cost
solve minimize total_cost;

% Output solution
output [ "numon: " ++ show(numon) ];