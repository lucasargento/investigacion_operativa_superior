include "globals.mzn"; 

% number of elements in the cross
int: n;
% elements in the cross
array[1..n] of var 1..n: x;

% elements in the cross
array[1..n] of set of 1..n: g;

solve satisfy;
% solve :: int_search(x, input_order, indomain_min, complete) satisfy;

constraint
  all_different(x)
  /\
  forall(i in 1..n) (
     forall(j in g[i]) (
        abs(x[i]-x[j]) > 1 
     )
  )
  %% symmetry breaking
  /\ x[1] < x[n]
  /\ x[1] < x[2]
;

% Problem 1
% output [
%    show(x) ++ "\n\n" ++ 
%    "  " ++ show(x[2]) ++ " " ++ show(x[5]) ++ "\n" ++
%    show(x[1]) ++ " " ++ show(x[3]) ++ " " ++ show(x[6]) ++ " " ++ show(x[8]) ++ "\n" ++
%    "  " ++ show(x[4]) ++ " " ++ show(x[7]) ++ "\n"  
% ];

% Problem 2
output [
    show(x) ++ "\n\n" ++ 

    "   " ++ show_int(2, x[3]) ++ " " ++ show_int(2, x[7]) ++ "\n" ++
    show_int(2, x[1]) ++ " " ++ show_int(2, x[4]) ++ " " ++ show_int(2, x[8]) ++ " " ++ show_int(2, x[11]) ++ "\n" ++
    show_int(2, x[2]) ++ " " ++ show_int(2, x[5]) ++ " " ++ show_int(2, x[9]) ++ " " ++ show_int(2, x[12]) ++ "\n" ++
    "   " ++ show_int(2, x[6]) ++ " " ++ show_int(2, x[10])
];


% Problem 1: 8 sized
% 
% (representation)
%   2 5
% 1 3 6 8
%   4 7
% 
% n = 8;
% g = [
%   {2,3,4},       % 1
%   {1,3,5,6},     % 2
%   {2,4,6,7},     % 3
%   {1,3,6,7},     % 4
%   {2,3,6,8},     % 5
%   {2,3,4,5,7,8}, % 6
%   {3,4,6,8},     % 7
%   {5,6,7}        % 8 
%   ];


%
% Problem 2: 12 sized
% (representation)
%   3 7
% 1 4 8 11
% 2 5 9 12
%   6 10
%
n = 12;
g = [
  {2,3,4,5}, % 1
  {1,4,5,6}, % 2
  {1,4,7,8}, % 3
  {1,2,3,5,7,8,9}, % 4
  {1,2,4,6,8,9,10}, % 5      
  {2,5,9,10}, % 6
  {3,4,8,11}, % 7
  {3,4,5,7,9,11,12}, % 8
  {4,5,6,8,10,11,12}, % 9
  {5,6,9,12}, % 10
  {7,8,9,12}, % 11
  {8,9,10,11}, % 12
];