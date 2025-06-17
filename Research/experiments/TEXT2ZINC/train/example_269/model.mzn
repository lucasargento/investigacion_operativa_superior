include "globals.mzn";

% The given amount of money
int: n = 13;

% The coin denominations
set of int: Coins = 1..n;

% The number of coins of each denomination
array[Coins] of var 0..n: x;

% The objective is to minimize the total number of coins
var int: total = sum(c in Coins) (x[c]);

% The sum of the coins must equal the given amount of money
constraint sum(c in Coins) (c*x[c]) = n;

% The objective is to minimize the total number of coins
solve minimize total;

% Output the solution
output ["The minimum number of coins is: ", show(total), "\n"];