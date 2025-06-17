include "globals.mzn"; 

int: num_p = 5; % number of people
int: num_b = 4; % number of bridges
% int: num_b = 13; % number of bridges (extra: build at bridge at any place)

% How many bridges to build
int: num_bridges_to_build = 2;

% position of home/work
array[1..num_p, 1..4] of int: pos;

% x-coordinate of the bridges
array[1..num_b] of int: bridges;

% distances from home -> bridges (first cell)
array[1..num_p, 1..num_b] of int: dist1 = 
  array2d(1..num_p, 1..num_b, 
  [
    abs(pos[p,1] - bridges[b])+
    abs(pos[p,2] - 6)

    | p in 1..num_p, b in 1..num_b
  ]);

% distances from bridges (last cell) -> work
array[1..num_p, 1..num_b] of int: dist2 = 
  array2d(1..num_p, 1..num_b, 
  [
    abs(pos[p,3] - bridges[b])+
    abs(pos[p,4] - -1)
    | p in 1..num_p, b in 1..num_b
  ]);

array[1..num_p] of  string: str;

%
% decision variables
% 
% which bridges to build
array[1..num_bridges_to_build] of var 1..num_b: x;

% which is the nearest bridge
array[1..num_p] of var 1..num_b: b_ix;

% total distance
var int: tot_dist;

% solve satisfy;
solve minimize tot_dist;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;


% I assume that the indices are ordered and unique
predicate min_index(var int: mi, array[int] of var int: x) =
  exists(i in index_set(x)) (
     x[i] = min(x) % minimum(x[i], x)
     /\
     mi = i 
  )
;

constraint

  % % output of the two dists matrices
  forall(p in 1..num_p) (
    trace(show([dist1[p,b] | b in 1..num_b]) ++ " -> " ++  
          show([dist2[p,b] | b in 1..num_b]) ++
          "\n", 1=1)
  )
  /\

  tot_dist = sum(p in 1..num_p) (
                min(
                   [dist1[p,x[b]] + 1 + dist2[p,x[b]] | b in 1..num_bridges_to_build]
                )
             )

  /\ % which bridge is the nearest (as index in x) ?
  forall(p in 1..num_p) (
    let {
      var 1..num_b: min_b_ix
    } in
       min_index(min_b_ix, [dist1[p,x[b]] + 1 + dist2[p,x[b]] | b in 1..num_bridges_to_build])
       /\
       b_ix[p] = min_b_ix
  )

  % /\ x[1] < x[2] % symmetry breaking
  /\ alldifferent(x)
  /\ increasing(x)
;




% for solve satisfy
% constraint tot_dist = 58;
% constraint tot_dist = 56; % for 3 bridges

output [
  "tot_dist: " ++ show(tot_dist) ++ "\n" ++
  "bridges: " ++ show(x) ++ "\n" ++ "\n" ++
  "Distances:\n"
]
++
% [
%   show(str[p]) ++ ": " ++
%   if 
%      fix(dist1[p,x[1]] + 1 + dist2[p,x[1]]) < 
%      fix(dist1[p,x[2]] + 1 + dist2[p,x[2]])
%   then 
%      show(dist1[p,x[1]]) ++ " + " ++ show(dist2[p,x[1]]) ++ " + 1 (bridge " ++ show(x[1]) ++ ") "
%   else 
%      show(dist1[p,x[2]]) ++ " + " ++ show(dist2[p,x[2]]) ++ " + 1 (bridge " ++ show(x[2]) ++ ") "
%   endif
%   ++ " = total distance: " ++
%   show(fix(min(
%      dist1[p,x[1]] + 1 + dist2[p,x[1]],
%      dist1[p,x[2]] + 1 + dist2[p,x[2]])
%   )) ++ "\n"
%   | p in 1..num_p
% ]
[
   % let {
   %    array[1..num_bridges_to_build] of var int: bb = [dist1[p,x[b]] + 1 + dist2[p,x[b]] | b in 1..num_bridges_to_build],
   %    var int: min_b = min(bb)
   % }
  let {
      array[1..num_bridges_to_build] of int: bb = [fix(dist1[p,fix(x[b])]) + 1 + fix(dist2[p,x[b]]) | b in 1..num_bridges_to_build],
      int: min_b = min(bb)
   }
   in
   show(str[p]) ++ ": " ++
   show(fix(min_b)) ++ " using bridge " ++ show(b_ix[p]) ++ " (at row " ++ show(bridges[x[b_ix[p]]]) ++ ")"
   ++ "\n"
   | p in 1..num_p
]
++ ["\n"]
;



%
% Data
%

%    1 2 3 4 5           1 2 3 4 5
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 1
%    0,0,0,A,0,  1,1,1,  0,B,0,0,0, % 2
%    0,B,0,0,0,  0,0,0,  0,0,0,0,0, % 3
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 4
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 5
%    0,0,C,0,0,  0,0,0,  0,0,0,A,0, % 6
%    0,D,0,0,0,  2,2,2,  0,0,0,0,0, % 7
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 8
%    0,0,0,0,0,  0,0,0,  0,C,0,0,0, % 9
%    0,E,0,0,0,  3,3,3,  0,0,0,0,0, % 10
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 11
%    0,0,0,0,0,  4,4,4,  0,E,0,D,0, % 12
%    0,0,0,0,0,  0,0,0,  0,0,0,0,0, % 13

pos = array2d(1..num_p, 1..4,
[
% home work
  2,4,  6,4,  % A 
  3,2,  2,2,  % B
  6,3,  9,2,  % C
  7,2, 12,4,  % D
 10,2, 12,2   % E
]);

% x coordinates for the bridges
bridges = [2,7,10,12];

% Testing: what if we can build 2 bridges at any places?
% x coordinates for the bridges
% bridges = [1,2,3,4,5,6,7,8,9,10,11,12,13];

str = ["A","B","C","D","E"];