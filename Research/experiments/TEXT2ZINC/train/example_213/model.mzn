% Parameters
int: N; % Number of clusters
array[1..N] of int: processing_times_central_isolate;
array[1..N] of int: processing_times_central_scan;
array[1..N] of int: processing_times_distributed_isolate;
array[1..N] of int: processing_times_distributed_scan;
int: costs_central;
int: costs_distributed;
int: max_hours_central_max_hours;
int: max_hours_distributed_max_hours;

% Decision Variables
array[1..N] of var 0..1: isolate_central;
array[1..N] of var 0..1: scan_central;
array[1..N] of var 0..1: isolate_distributed;
array[1..N] of var 0..1: scan_distributed;

% Constraints
constraint forall(i in 1..N) (
    isolate_central[i] + scan_central[i] + isolate_distributed[i] + scan_distributed[i] = 1
);

constraint sum(i in 1..N) (isolate_central[i]*processing_times_central_isolate[i] + scan_central[i]*processing_times_central_scan[i]) <= max_hours_central_max_hours;
constraint sum(i in 1..N) (isolate_distributed[i]*processing_times_distributed_isolate[i] + scan_distributed[i]*processing_times_distributed_scan[i]) <= max_hours_distributed_max_hours;

% Objective Function
var int: total_cost = sum(i in 1..N) (
    isolate_central[i]*processing_times_central_isolate[i]*costs_central +
    scan_central[i]*processing_times_central_scan[i]*costs_central +
    isolate_distributed[i]*processing_times_distributed_isolate[i]*costs_distributed +
    scan_distributed[i]*processing_times_distributed_scan[i]*costs_distributed
);

solve minimize total_cost;

% Output
output [ if fix(isolate_central[i]) = 1 then "isolate_central" else if fix(scan_central[i]) = 1 then "scan_central" else if fix(isolate_distributed[i]) = 1 then "isolate_distributed" else "scan_distributed" endif endif endif | i in 1..N] ++ ["\nTotal cost: ", show(total_cost)];