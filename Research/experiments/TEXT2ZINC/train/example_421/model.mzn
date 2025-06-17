var 0..120: x1;
% number of bottles of ginger bubble tea
var 0..200: x2; 

% the store can make a maximum of 300 bottles of bubble tea per day
constraint x1 + x2 <= 300;

% profit from almond bubble tea is $5 each and from ginger bubble tea is $9 each
var int: profit = 5*x1 + 9*x2;

% maximize profit
solve maximize profit;

output ["Almond bubble tea: " ++ show(x1) ++ "\nGinger bubble tea: " ++ show(x2) ++ "\nProfit: $" ++ show(profit)];