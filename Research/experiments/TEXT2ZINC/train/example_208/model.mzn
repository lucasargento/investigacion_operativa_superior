% Parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: time_required; % Time required to produce a batch on machine m for part p
array[1..M] of int: machine_costs; % Cost of operating machine m for a month
array[1..M] of int: availability; % Time each machine m is available for production each month
array[1..P] of int: prices; % Price at which part p can be sold
array[1..P] of int: setup_time; % Setup time required before producing a batch of part p

% Decision Variables
array[1..P] of var 0..availability[1] div (time_required[1,1] + setup_time[1]): batches; % Number of batches of each part to produce
array[1..P] of var 0..1: setup_flags; % Whether part p is set up or not

% Constraints
constraint forall(m in 1..M)(
    sum(p in 1..P)(time_required[m,p] * batches[p]) + sum(p in 1..P)(setup_flags[p] * setup_time[p]) <= availability[m]
);

% Objective
var int: total_profit = sum(p in 1..P)(prices[p] * batches[p]) - sum(m in 1..M)(machine_costs[m] * availability[m]);
solve maximize total_profit;

% Output
output ["batches: ", show(batches), "\n", "setup_flags: ", show(setup_flags), "\n", "total_profit: ", show(total_profit)];