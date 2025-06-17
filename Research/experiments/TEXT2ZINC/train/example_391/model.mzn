include "globals.mzn";

% Ensure that we use pennies.
set of float: pennies = { i/100 | i in 1..7*100 } ; 
array[1..4] of var pennies: item;

constraint
  sum(item) = 7.11 /\
  product(item) = 7.11;
  
% symmetry breaking
constraint increasing(item);

% solve satisfy;
solve :: float_search(item,0.01, input_order, indomain_split) satisfy;

output [
   show(item), "\n",
];