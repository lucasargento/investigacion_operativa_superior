var int: housing;
var int: roads;
var int: total_investment;

constraint total_investment = housing + roads;
constraint total_investment <= 3500;
constraint housing >= 750;
constraint roads >= 0.24 * total_investment;

var float: profit;

constraint profit = 0.95 * housing + 0.32 * roads;

solve maximize profit;