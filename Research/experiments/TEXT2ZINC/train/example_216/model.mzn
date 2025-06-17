% Parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: time_required; % Time required to produce each part on each machine
array[1..M] of int: machine_costs; % Cost per hour for each machine
array[1..M] of int: availability; % Availability of each machine
array[1..P] of int: prices; % Selling price for each part
array[1..P] of int: min_batches; % Minimum batches required for each part
array[1..M] of int: extra_costs; % Extra cost for each machine
array[1..M] of int: max_extra; % Maximum extra hours for each machine

% Decision Variables
array[1..P] of var 0..1000: batches; % Number of batches for each part
array[1..M] of var 0..max_extra[m]: extra_time; % Extra time for each machine

% Objective
var int: total_profit;
maximize total_profit;

% Constraints
constraint forall(m in 1..M)(
    sum(p in 1..P)(time_required[m,p]*batches[p]) <= availability[m] + extra_time[m]
);

constraint forall(p in 1..P)(
    batches[p] >= min_batches[p]
);

constraint forall(m in 1..M)(
    extra_time[m] <= max_extra[m]
);

constraint total_profit = sum(p in 1..P)(prices[p]*batches[p]) - sum(m in 1..M)(machine_costs[m]*(availability[m] + extra_time[m])) - sum(m in 1..M)(extra_costs[m]*extra_time[m]);