var int: juice;
% number of cups of milk
var int: milk;

% number of cups are non-negative
constraint juice >= 0;
constraint milk >= 0;

% patient needs to consume at least 180 units of vitamins
% juice contains 12 units of vitamins and milk contains 14 units of vitamins
constraint 12*juice + 14*milk >= 180;
% patient needs to consume at least 140 units of hydration
% juice contains 8 units of hydration and milk contains 10 units of hydration
constraint 8*juice + 10*milk >= 140;

% there must be at most 10% of all cups of drinks be vitamin-added milk
constraint milk <= 0.1*(juice + milk);

% juice contains 10 units of sugar and milk contains 3 units of sugar
var int: sugar = 10*juice + 3*milk;

% minize sugar intake
solve minimize sugar;

output ["Juice: " ++ show(juice) ++ "\nMilk: " ++ show(milk)];