% Parameters
int: N; % Number of cities
array[1..N, 1..N] of int: Distances; % Distance matrix
int: StartCity; % Starting city

% Decision Variables
array[1..N+1] of var 1..N: visit_order; % Order of cities visited
var int: total_distance; % Total distance travelled

% Constraints
% Start and end at the start city
constraint visit_order[1] = StartCity;
constraint visit_order[N+1] = StartCity;

% Each city is visited exactly once
include "globals.mzn";
constraint alldifferent(visit_order[1..N]);

% Total distance is the sum of the distances between consecutive cities
constraint total_distance = sum(i in 1..N)(Distances[visit_order[i], visit_order[i+1]]);

% Objective
solve minimize total_distance;

% Output
output ["visit_order: ", show(visit_order), "\n", "total_distance: ", show(total_distance)];