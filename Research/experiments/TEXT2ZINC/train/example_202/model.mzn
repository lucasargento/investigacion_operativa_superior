% Define parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: time_required; % Time required by each machine to produce each part
array[1..M] of int: machine_costs; % Cost of using each machine
array[1..M] of int: availability; % Availability of each machine
array[1..P] of int: prices; % Selling price of each part
array[1..P] of int: min_batches; % Minimum batches of each part to be produced

% Define decision variables
array[1..P] of var min_batches[1..P]..sum(i in 1..M)(availability[i] div time_required[i, 1..P]): batches; % Number of batches of each part to be produced

% Define objective function
var int: total_profit = sum(p in 1..P)(prices[p] * batches[p]) - sum(m in 1..M)(machine_costs[m] * sum(p in 1..P)(time_required[m, p] * batches[p]));

% Define constraints
constraint forall(m in 1..M-1)(sum(p in 1..P)(time_required[m, p] * batches[p]) <= availability[m]); % Machine availability constraint
constraint sum(p in 1..P)(time_required[M, p] * batches[p]) + sum(p in 1..P)(time_required[M-1, p] * batches[p]) <= availability[M]; % Shared availability constraint for last two machines

% Maximize total profit
solve maximize total_profit;

% Output solution
output ["batches: ", show(batches), "\ntotal_profit: ", show(total_profit)];