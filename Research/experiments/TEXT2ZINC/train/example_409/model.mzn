var int: ham; 
% number of kgs of bacon
var int: bacon; 

% kgs of ham and bacon produced must be non-negative
constraint ham >= 0;
constraint bacon >= 0;

% total machine time available is 2000
% each kg of ham takes 15 minutes of machine time and each kg of bacon takes 8 minutes of machine time
constraint 15 * ham + 8 * bacon <= 2000; 

% profit per kg of ham is $20 and for bacon is $12
var int: profit = 20 * ham + 12 * bacon; 

% maximize profit
solve maximize profit; 

output ["ham=", show(ham), "\n", "bacon=", show(bacon), "\n", "profit=", show(profit)];