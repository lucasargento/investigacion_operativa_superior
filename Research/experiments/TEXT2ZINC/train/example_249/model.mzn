% Parameters
int: P; % Number of parts
int: M; % Number of machines
array[1..M, 1..P] of int: time_required; % Time required by each machine to produce each part
array[1..M] of int: machine_costs; % Cost of each machine
array[1..M] of int: availability; % Availability of each machine
array[1..P] of int: prices; % Price of each part
array[1..P] of int: min_batches; % Minimum batches required for each part
int: standard_cost; % Standard cost of running a machine per hour
int: overtime_cost; % Overtime cost of running a machine beyond the standard hours
int: overtime_hour; % Overtime hours available for each machine
int: min_profit; % Minimum profit that the manufacturer aims to achieve

% Decision Variables
array[1..P] of var 0..1000: batches; % Number of batches for each part
var int: total_profit; % Total profit

% Constraints
constraint forall(m in 1..M)(
    sum(p in 1..P)(time_required[m,p]*batches[p]) <= availability[m]
);

constraint forall(p in 1..P)(
    batches[p] >= min_batches[p]
);

constraint sum(p in 1..P)(prices[p]*batches[p]) - sum(m in 1..M)(machine_costs[m]*sum(p in 1..P)(time_required[m,p]*batches[p])) - (if sum(p in 1..P)(time_required[1,p]*batches[p]) > overtime_hour then (sum(p in 1..P)(time_required[1,p]*batches[p]) - overtime_hour)*overtime_cost else 0 endif) >= min_profit;

% Objective
solve maximize total_profit;

% Output
output ["batches: ", show(batches), "\n", "total_profit: ", show(total_profit)];