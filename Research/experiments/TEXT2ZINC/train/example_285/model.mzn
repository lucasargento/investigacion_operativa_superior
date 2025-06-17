include "alldifferent.mzn";

% Define the number of nodes and colors
int: n = 5; % number of nodes
int: m = 3; % number of colors

% Define the adjacency matrix
array[1..n, 1..n] of 0..1: adj = array2d(1..n, 1..n, [
  0, 1, 0, 0, 1,
  1, 0, 1, 0, 1,
  0, 1, 0, 1, 0,
  0, 0, 1, 0, 1,
  1, 1, 0, 1, 0
]);

% Define the decision variables
array[1..n] of var 1..m: color;

% Define the constraints
constraint forall(i in 1..n, j in i+1..n) (
  if adj[i,j] = 1 then
    color[i] != color[j]
  endif
);

% Define the objective function
var int: obj = sum(i in 1..n) (color[i]);

% Define the optimization problem
solve minimize obj;

% Output the solution
output [ "Color of node " ++ show(i) ++ ": " ++ show(color[i]) ++ "\n" | i in 1..n ];