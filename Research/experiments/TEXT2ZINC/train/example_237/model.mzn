% Parameters
int: K; % Maximum value of random variable Z
array[0..K] of float: P; % Probabilities of Z taking values 0, 1, ..., K
float: ExpectedZ; % First moment of Z
float: ExpectedZSquared; % Second moment of Z

% Decision Variables
var float: lower_bound; % Lower bound on the fourth moment of Z
var float: upper_bound; % Upper bound on the fourth moment of Z

% Constraints
constraint lower_bound <= upper_bound; % Lower bound should be less than or equal to upper bound

% Objective Function
solve minimize lower_bound;
solve maximize upper_bound;

% Output
output ["lower_bound: ", show(lower_bound), "\n", "upper_bound: ", show(upper_bound)];