include "globals.mzn";

% number of packages of seafood medley one
var int: medley_one;
% number of packages of seafood medley two
var int: medley_two;

% number of packages are non-negative
constraint medley_one >= 0;
constraint medley_two >= 0;

% number of available scallops is 10000 grams
% medley one contains 20 grams of scallops and medley two contains 40 grams of scallops
constraint 20 * medley_one + 40 * medley_two <= 10000;

% number of available mussels is 12000 grams
% medley one contains 30 grams of mussels and medley two contains 40 grams of mussels
constraint 30 * medley_one + 40 * medley_two <= 12000;

% number of available oysters is 11000 grams
% medley one contains 50 grams of mussels and medley two contains 20 grams of mussels
constraint 50 * medley_one + 20 * medley_two <= 11000;

% profit from medley one is $20 each and profit from medley two is $25 each 
var int: profit = 20 * medley_one + 25 * medley_two;

% maximize profit
solve maximize profit;

% output
output ["Seafood Medley One: " ++ show(medley_one) ++ "\nSeafood Medley Two: " ++ show(medley_two) ++ "\nProfit: $" ++ show(profit)];