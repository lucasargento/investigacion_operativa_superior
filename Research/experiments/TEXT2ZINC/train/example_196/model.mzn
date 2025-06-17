% Parameters
int: large_roll_width;
array[1..4] of int: demands;
array[1..4] of float: roll_width_options;
array[1..49, 1..4] of int: patterns;

% Variables
array[1..49] of var 0..1000: pattern_amounts; % Amount of each pattern to use
var int: total_large_rolls; % Total number of large rolls used

% Constraints
constraint total_large_rolls = sum(pattern_amounts); % Total large rolls is sum of all pattern amounts

% For each type of smaller roll, the total produced must meet or exceed the demand
constraint forall(j in 1..4) (
    sum(i in 1..49) (patterns[i,j] * pattern_amounts[i]) >= demands[j]
);

% Objective: Minimize the total number of large rolls used
solve minimize total_large_rolls;

% Output
output [ "patterns: " ] ++
[ if fix(pattern_amounts[i]) > 0 then
    "{ \"pattern\": " ++ show([patterns[i,j] | j in 1..4]) ++ ", \"amount\": " ++ show(pattern_amounts[i]) ++ " },\n"
  else "" endif | i in 1..49
] ++
[ "total_large_rolls_used: " ++ show(total_large_rolls) ];