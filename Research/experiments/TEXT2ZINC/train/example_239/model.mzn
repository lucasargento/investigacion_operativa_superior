% Define parameters
int: P; % Number of parts
int: M; % Number of machines
array[1..M, 1..P] of int: time_required; % Time required to produce one batch of each part on each machine
array[1..M] of int: machine_costs; % Cost per hour for using each machine
array[1..M] of int: availability; % Monthly availability of each machine
array[1..P] of int: prices; % Price per batch for each part
array[1..P] of int: min_batches; % Minimum production requirement for each part

% Define decision variables
array[1..P] of var 0..1000: batches; % Number of batches of each part to produce

% Define objective function
var int: total_profit = sum(p in 1..P) (prices[p] * batches[p]) - sum(m in 1..M) (machine_costs[m] * sum(p in 1..P) (time_required[m,p] * batches[p]));

% Define constraints
constraint forall(m in 1..M) (sum(p in 1..P) (time_required[m,p] * batches[p]) <= availability[m]); % Machine availability constraint
constraint forall(p in 1..P) (batches[p] >= min_batches[p]); % Minimum production requirement constraint

% Maximize total profit
solve maximize total_profit;

% Output solution
output ["batches: ", show(batches), "\n", "total_profit: ", show(total_profit)];