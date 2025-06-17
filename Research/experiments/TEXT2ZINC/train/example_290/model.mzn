include "globals.mzn";

% Define the range of possible numbers
set of int: NUM = 1..99999;

% Define the variable for the Dudeney number
var NUM: dudeney_number;

% Define the variable for the cube root of the Dudeney number
var 1..215: cube_root;

% The Dudeney number is the cube of another number
constraint dudeney_number = cube_root * cube_root * cube_root;

% The sum of the digits of the Dudeney number is equal to the cube root
constraint sum([dudeney_number div 10^i mod 10 | i in 0..4]) = cube_root;

% Find the Dudeney numbers
solve satisfy;

% Output the Dudeney numbers
output ["Dudeney number: " ++ show(dudeney_number) ++ "\nCube root: " ++ show(cube_root) ++ "\n"];