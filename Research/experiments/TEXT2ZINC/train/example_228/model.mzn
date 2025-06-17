% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of float: west_time; % Time to cross each east-west street segment
array[1..N-1, 1..W] of float: north_time; % Time to cross each north-south street segment

% Decision Variables
array[1..N, 1..W] of var 0..1: path; % 1 if the delivery person passes through the intersection, 0 otherwise
array[1..N, 1..W-1] of var 0..1: west_path; % 1 if the delivery person goes west at the intersection, 0 otherwise
array[1..N-1, 1..W] of var 0..1: north_path; % 1 if the delivery person goes north at the intersection, 0 otherwise

% Objective
var float: total_time; % Total time taken to deliver the package

% Constraints
constraint forall(i in 1..N, j in 1..W-1) (
    west_path[i,j] = path[i,j] - path[i,j+1]
);

constraint forall(i in 1..N-1, j in 1..W) (
    north_path[i,j] = path[i,j] - path[i+1,j]
);

constraint path[1,1] = 1;
constraint path[N,W] = 1;

constraint forall(i in 1..N, j in 1..W) (
    if i < N then
        path[i,j] = path[i+1,j] + sum(k in 1..j) (west_path[i,k])
    elseif j < W then
        path[i,j] = path[i,j+1] + sum(k in 1..i) (north_path[k,j])
    else
        path[i,j] = 1
    endif
);

% Objective Function
solve minimize total_time = sum(i in 1..N, j in 1..W-1) (west_path[i,j]*west_time[i,j]) + sum(i in 1..N-1, j in 1..W) (north_path[i,j]*north_time[i,j]);

% Output
output ["paths: ", show([(i,j) | i in 1..N, j in 1..W where path[i,j] = 1]), "\n", "total_time: ", show(total_time)];