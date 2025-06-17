include "globals.mzn";

% number of long-term cruise tickets
var 35..1500: long_term;
% number of week-long cruise tickets
var 0..1500: week_long;

% total number of people on the cruise ship
constraint long_term + week_long <= 1500;

% at least 4 times as many people prefer to buy week-long cruise tickets than long-term cruise tickets
constraint week_long >= 4 * long_term;

% profit from each type of ticket, 500 for long term and 150 for short term
var int: profit_long_term = 500 * long_term;
var int: profit_week_long = 150 * week_long;

% total profit
var int: total_profit = profit_long_term + profit_week_long;

% maximize total profit
solve maximize total_profit;

output ["Long-term tickets: " ++ show(long_term) ++ "\nWeek-long tickets: " ++ show(week_long) ++ "\nTotal profit: " ++ show(total_profit)];