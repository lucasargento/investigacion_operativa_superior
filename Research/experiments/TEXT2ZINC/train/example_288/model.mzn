include "globals.mzn";

% Define the variables
var 0..711: item1;
var 0..711: item2;
var 0..711: item3;
var 0..711: item4;

% The sum of the prices of the four items must equal $7.11
constraint item1 + item2 + item3 + item4 = 711;

% The product of the prices of the four items must equal $7.11
constraint item1 * item2 * item3 * item4 = 711000000;

% The prices of the items must be different
constraint alldifferent([item1, item2, item3, item4]);

% Solve the problem
solve satisfy;

% Output the solution
output ["Item 1: " ++ show(item1), "\nItem 2: " ++ show(item2), "\nItem 3: " ++ show(item3), "\nItem 4: " ++ show(item4)];