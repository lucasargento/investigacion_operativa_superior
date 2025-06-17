include "globals.mzn";

% Define the parameters
int: r = 21; % Maximum sum of triplets
int: n = 12; % Number of clock numbers

% Define the decision variables
array[1..n] of var 1..n: clock_numbers;

% Define the constraints
constraint alldifferent(clock_numbers);

% Ensure that no three adjacent numbers have a sum exceeding r
constraint forall(i in 1..n-2)(clock_numbers[i] + clock_numbers[i+1] + clock_numbers[(i+2 mod n) + 1] <= r);

% Ensure that the last two numbers and the first number do not exceed r
constraint clock_numbers[n-1] + clock_numbers[n] + clock_numbers[1] <= r;
constraint clock_numbers[n] + clock_numbers[1] + clock_numbers[2] <= r;

% Define the objective function
solve satisfy;

% Output the solution
output ["Clock Numbers: " ++ show(clock_numbers)];