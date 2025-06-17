var int: syrup1;
%units of syrup2
var int: syrup2;

% servings are non-negative
constraint syrup1 >= 0;
constraint syrup2 >= 0;

% medicine delivered to the throat is at most 5 units
% syrup 1 delivers 0.5 units of medicine to the throat and syrup 2 delivers 0.2 units 
constraint syrup1 * 0.5 + syrup2 * 0.2 <= 5;
% medicine delivered to the lungs is at least 4 units
% syrup 1 delivers 0.4 units of medicine to the lungs and syrup 2 delivers 0.5 units
constraint syrup1 * 0.4 + syrup2 * 0.5 >= 4;

% syrup 1 contains 0.5 units of sugar while syrup 2 contains 0.3 units of sugar per serving
var float: sugar = syrup1 * 0.5 + syrup2 * 0.3;

% minimize sugar
solve minimize sugar;

output ["Syrup 1: " ++ show(syrup1) ++ "\nSyrup 2: " ++ show(syrup2)];