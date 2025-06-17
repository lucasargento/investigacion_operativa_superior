include "globals.mzn"; 

% int: n = 4; 
% array[1..n, 1..2] of int: input = array2d(1..n, 1..2, [1009, 2000,
%                                                        1009, 2001,
%                                                        1002, 2002,
%                                                        1003, 2002]);

int: n = 5;
array[1..n, 1..2] of int: input = array2d(1..n, 1..2, [1009, 2000,
                                                       1009, 2001,
                                                       1002, 2002,
                                                       1003, 2002,
                                                       1004, 2003]);

% example from a comment (n.m.)
% (unsolvable)
% int: n = 3;
% array[1..n, 1..2] of int: input = array2d(1..n,  1..2, [1,2,
%                                                         2,3,
%                                                         3,1
%                                                         ]);

% the ids (for the domains in s)
set of int: ids = { input[i,j] | i in 1..n, j in 1..2};

% decision variables
var set of ids: s;



% solve satisfy;
solve minimize(card(s));
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

% Testing first example (unique solution)
% constraint card(s) = 2;

% Testing second example (2 solutions)
% constraint card(s) = 3;

constraint
   forall(i in 1..n) (
      % "Only one member should be choose from each Group"
      % -> xor
      input[i,1] in s xor input[i,2] in s
   )
;

output [
  "ids: " ++ show(ids) ++ "\n" ++
  "s  : " ++ show(s) ++ "\n" ++ 
  "card(s): " ++ show(card(s)) ++ "\n"
]
 ++ ["\n"]
;