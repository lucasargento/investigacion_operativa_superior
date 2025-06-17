include "globals.mzn"; 

int: num_segments = 6;
array[1..num_segments] of int: s = [ 4,2,4,4,6,8 ]; % original problem
% array[1..num_segments] of int: s = [2, 3, 5, 1, 8, 9]; % from a comment

% from a comment: unsolvable problem
% int: num_segments = 4;
% array[1..num_segments] of int: s = [1,2,3,4];

% Generating problems
% int: num_segments = 6;
% array[1..num_segments] of var 1..10: s;

int: n = 4;
array[1..n] of var 1..sum(s): sum_sides;
array[1..n] of var 1..num_segments: num_sides;
% array[1..n] of var 1..num_segments*num_segments: sum_sides; % For generating

% decision variable
% 
%    Sides
%         1 
%     - - - - - 
%    |         |
%    |         |
%  4 |         | 2
%    |         |
%    |         |
%     - - - - -
%         3
%
% on which side should this segments be placed?
array[1..num_segments] of var 1..4: x;

% area
var 0..sum(s)*2: area; 
% var 0..1000: area;  % For generating

% solve maximize area;
% solve satisfy;
% solve :: int_search(x, anti_first_fail, indomain_split, complete) maximize area;
solve :: int_search(x, 
        anti_first_fail, % max_regret, 
        indomain_split, 
        complete) 
    maximize area;
    % satisfy; % Generating

% constraint area = 48;

% constraint
%   % For generating problems we assume that s is sorted
%   increasing(s)
% ;


constraint
   % Get the sums of each side
   % (also ensure that each side get an assignment in x)
   forall(j in 1..n) (
     sum_sides[j] = sum(i in 1..num_segments) ( s[i]*bool2int(x[i]=j) )
     /\
     num_sides[j] = sum(i in 1..num_segments) ( bool2int(x[i]=j) )
   )
;

% Ensure that the sides are of the same length
constraint
   % Upper = lower
   sum_sides[1] = sum_sides[3]

   /\
   % left = right
   sum_sides[2] = sum_sides[4]
;

% The area
constraint
  area =  sum_sides[1] * sum_sides[2]
;

% % Symmetry breaking
constraint
   % x[1] = 1 % we assign first segment to first side

   % Another symmetry breaking (not coherent with the one above)
   num_sides[1] <= num_sides[3] /\
   num_sides[2] <= num_sides[4]
;


output [
  "s:   : " ++ show(s) ++ "\n" ++ 
  "area : " ++ show(area) ++ "\n" ++
  "x    : " ++ show(x) ++ "\n" ++
  "sum_sides: " ++ show(sum_sides) ++ "\n" ++
  "num_sides: " ++ show(num_sides) ++ "\n"
]
++
[
   "         " ++
   show([s[i] | i in 1..num_segments where fix(x[i]) = 1]) ++ "\n" ++
   show([s[i] | i in 1..num_segments where fix(x[i]) = 4]) ++ "                   " ++ 
   show([s[i] | i in 1..num_segments where fix(x[i]) = 2]) ++ "\n" ++
   "         " ++
   show([s[i] | i in 1..num_segments where fix(x[i]) = 3])
]
++ 
["\n"]
;