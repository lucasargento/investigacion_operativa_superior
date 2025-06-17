% Load data from .dzn file
include "globals.mzn";

% Define parameters
array[1..19] of float: y;
array[1..19] of float: x;

% Define decision variables
var float: quadratic;
var float: linear;
var float: constant;
array[1..19] of var float: deviations;

% Define constraints
constraint forall(i in 1..19) (
    deviations[i] = abs(y[i] - (quadratic * (x[i]^2) + linear * x[i] + constant))
);

% Define objective function
var float: total_deviation = sum(deviations);
solve minimize total_deviation;

% Output solution
output ["quadratic: ", show(quadratic), "\n",
        "linear: ", show(linear), "\n",
        "constant: ", show(constant), "\n"];