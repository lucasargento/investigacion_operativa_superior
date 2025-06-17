% Parameters
int: M; % Number of constraints
int: N; % Dimension of the problem
array[1..M, 1..N] of float: A; % Coefficients of the constraints
array[1..M] of float: B; % Right-hand side of the constraints

% Variables
var float: r; % Radius of the ball
array[1..N] of var float: y; % Center of the ball

% Constraints
constraint forall(i in 1..M)(
  sum(j in 1..N)(A[i,j]*y[j]) + r*sqrt(sum(j in 1..N)(A[i,j]^2)) <= B[i]
);

% Objective
solve maximize r;

% Output
output ["{\"center\": [", join(", ", [show(y[j]) | j in 1..N]), "], \"radius\": ", show(r), "}"];