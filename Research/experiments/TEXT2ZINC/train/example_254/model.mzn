% Parameters
int: n_mines; % Number of mines
int: n_maxwork; % Maximum number of mines that can be operated in a year
array[1..n_mines] of float: royalty; % Royalty cost for each mine
array[1..n_mines] of float: limit; % Production limit for each mine
array[1..n_mines] of float: quality; % Quality of material from each mine
array[1..5] of float: requiredquality; % Required quality for each year
float: price; % Price per unit of material
float: discount; % Discount rate

% Decision Variables
array[1..n_mines, 1..5] of var 0..1: isoperated; % Whether each mine is operated in each year
array[1..n_mines, 1..5] of var 0.0..limit[1..n_mines]: amount; % Amount of ore produced by each mine in each year

% Constraints
constraint forall(i in 1..5) (
    sum(k in 1..n_mines) (isoperated[k, i]) <= n_maxwork % At most n_maxwork mines can be operated in a year
);

constraint forall(i in 1..5) (
    sum(k in 1..n_mines) (amount[k, i] * quality[k]) = requiredquality[i] * sum(k in 1..n_mines) (amount[k, i]) % The quality of the blended ore must meet the required quality
);

constraint forall(k in 1..n_mines, i in 1..5) (
    amount[k, i] <= limit[k] * isoperated[k, i] % The amount of ore produced by a mine cannot exceed its limit
);

% Objective
var float: profit; % Total profit
constraint profit = sum(i in 1..5) (price * sum(k in 1..n_mines) (amount[k, i]) - sum(k in 1..n_mines) (royalty[k] * isoperated[k, i])) * pow(1 - discount, i - 1);
solve maximize profit;

% Output
output [ if fix(isoperated[k, i]) = 1 then "1" else "0" endif | k in 1..n_mines, i in 1..5] ++ [ "\n" ] ++
       [ show(fix(amount[k, i])) | k in 1..n_mines, i in 1..5];