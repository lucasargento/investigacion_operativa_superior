% Parameters
int: S; % Number of schools
int: G; % Number of student groups
int: N; % Number of neighborhoods
array[1..S, 1..G] of int: Capacity; % Capacity of each school for each student group
array[1..N, 1..G] of int: Population; % Population of each student group in each neighborhood
array[1..N, 1..S] of float: Distance; % Distance from each neighborhood to each school

% Decision Variables
var array[1..N, 1..S, 1..G] of float: x; % Number of students of each group from each neighborhood assigned to each school

% Objective
var float: total_distance = sum(n in 1..N, s in 1..S, g in 1..G) (x[n,s,g] * Distance[n,s]);

% Constraints
constraint forall(n in 1..N, g in 1..G) (sum(s in 1..S) (x[n,s,g]) = Population[n,g]); % All students must be assigned to a school
constraint forall(s in 1..S, g in 1..G) (sum(n in 1..N) (x[n,s,g]) <= Capacity[s,g]); % School capacity must not be exceeded

% Solve
solve minimize total_distance;

% Output
output ["assignment: ", show(x), "\n", "total_distance: ", show(total_distance)];