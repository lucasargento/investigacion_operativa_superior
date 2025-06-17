% Parameters
int: N; % Number of road segments
int: M; % Number of lamps
array[1..N, 1..M] of float: Coefficients; % Coefficients for each road segment and lamp
array[1..N] of int: DesiredIlluminations; % Desired illuminations for each road segment

% Decision Variables
array[1..M] of var 0..100: power; % Power of each lamp
var 0..10000: error; % Absolute error between the illuminations and the desired illuminations

% Constraints
constraint forall(i in 1..N) (
    abs(sum(j in 1..M) (Coefficients[i,j]*power[j]) - DesiredIlluminations[i]) <= error
);

% Objective
solve minimize error;

% Output
output ["power: ", show(power), "\n", "error: ", show(error)];