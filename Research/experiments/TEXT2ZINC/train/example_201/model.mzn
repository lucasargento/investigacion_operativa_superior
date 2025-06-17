% Define the parameters
int: NumObs; % Number of observations
array[1..NumObs] of float: Y; % Observed values of y
array[1..NumObs] of float: X; % Observed values of x

% Define the decision variables
var float: intercept; % Intercept of the fitted line
var float: slope; % Slope of the fitted line
array[1..NumObs] of var float: deviation; % Deviation of observed y from predicted y

% Constraints
constraint forall(i in 1..NumObs) (
    deviation[i] >= Y[i] - (slope * X[i] + intercept) /\
    deviation[i] >= (slope * X[i] + intercept) - Y[i]
);

% Objective: Minimize the maximum deviation
solve minimize max(deviation);

% Output the solution
output ["intercept: ", show(intercept), "\nslope: ", show(slope)];