% Parameters
int: n_working_days; % Number of consecutive working days
int: n_resting_days; % Number of consecutive resting days
array[1..N] of int: num; % Number of required employees each day

% Decision Variables
var int: total_number; % Total number of employees to hire
array[1..total_number, 1..N] of var 0..1: is_work; % Whether each employee is working each day

% Constraints
constraint total_number >= max(num); % At least the maximum number of required employees must be hired

% Each employee works for n_working_days consecutive days followed by at least n_resting_days consecutive resting days
constraint forall(i in 1..total_number, n in 1..N-n_working_days-n_resting_days+1) (
    sum(j in n..n+n_working_days-1) (is_work[i, j]) = n_working_days
    /\ sum(j in n+n_working_days..n+n_working_days+n_resting_days-1) (is_work[i, j]) = 0
);

% The number of working employees each day must meet the requirements
constraint forall(n in 1..N) (
    sum(i in 1..total_number) (is_work[i, n]) = num[n]
);

% Objective
solve minimize total_number;

% Output
output ["total_number: ", show(total_number), "\n", "is_work: ", show2d(is_work)];