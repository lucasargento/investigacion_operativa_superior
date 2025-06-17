include "globals.mzn";

% Variables
var 0..100: men;
var 0..100: women;
var 0..100: children;

% Constraints
constraint men * 3 + women * 2 + children * 0.5 = 100;
constraint men + women + children = 100;
constraint women = 5 * men;

% Solve
solve satisfy;

% Output
output ["Men: " ++ show(men) ++ "\n", "Women: " ++ show(women) ++ "\n", "Children: " ++ show(children)];