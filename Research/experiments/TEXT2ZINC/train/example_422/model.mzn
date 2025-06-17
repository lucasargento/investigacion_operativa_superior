var int: paperback;
% number of hardcover books produced
var int: hardcover;

% number of books is non-negative
constraint paperback >= 0;
constraint hardcover >= 0;

% there must be at least three times as many hardcover than paperback textbooks
constraint hardcover >= 3 * paperback;
% at least 100 paperback versions must be created
constraint paperback >= 100;
% the professor sells at least 1000 textbooks every year
constraint paperback + hardcover >= 1000;

% Paperback books yield a profit of $150 USD whereas hardcover versions yield a profit of $200 USD
var int: profit = 150 * paperback + 200 * hardcover;

% maximize profit
solve maximize profit; 

output ["Paperback: " ++ show(paperback) ++ "\n", "Hardcover: " ++ show(hardcover) ++ "\n", "Profit: " ++ show(profit) ++ "\n"];