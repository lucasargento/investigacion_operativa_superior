include "photo_hkj2_model.mzn";

n = 11;
num_pref = 20;

% solve :: int_search(positions, "first_fail", "indomain", "complete") maximize z;
solve :: int_search(positions, first_fail, indomain_min, complete) satisfy;

% for solve satisfy
% constraint 
%   z >= 12
% ;

% The preference list from 
% http://www.g12.cs.mu.oz.au/minizinc/photo.data2
preferences =
array2d(1..num_pref, 1..2, [ 
  0,2, 0,4, 0,7, 
  1,4, 1,8, 
  2,3, 2,4, 
  3,0, 3,4, 3,9,
  4,5, 4,0, 
  5,0, 5,8, 
  6,2, 6,7, 
  7,8, 7,6, 
  8,9, 
  9,10
]);



output [
   show(z), ": ", show(positions), "\n",
];