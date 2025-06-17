% Parameters
int: K; % Number of data points
array[1..K] of float: Y; % Observed values of Y
array[1..K] of float: X; % Corresponding values of X

% Decision Variables
var float: intercept; % Intercept of the fitted line
var float: slope; % Slope of the fitted line
array[1..K] of var float: deviation; % Absolute deviation of each observed value of Y from the predicted value

% Constraints
constraint forall(k in 1..K) (
    deviation[k] = abs(Y[k] - (slope * X[k] + intercept))
);

% Objective
solve minimize sum(deviation);