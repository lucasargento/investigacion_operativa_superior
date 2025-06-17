include "globals.mzn"; 

int: num_items;
int: max_item;
set of int: items = 1..max_item;
int: num_bids;

array[1..num_bids] of set of items: packages;
array[1..num_bids] of int: bids;

% the assignments
array[1..num_bids] of var 0..1: x;
var int: total;

% solve maximize total;
solve :: int_search(x, first_fail, indomain_min, complete) maximize total;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   total = sum(i in 1..num_bids) ( x[i]*bids[i] )

   /\ % ensure that each items is selected atmost once
   forall(j in 1..num_items) (
       sum(i in 1..num_bids) (x[i]*bool2int(j in packages[i])) <= 1
   )
   % test
   % /\ total = 11

;

%
% data
%
num_items = 7;
num_bids = 5;
max_item = 7;
packages = [
   {1,2,3,4},
   {2,3,6},
   {1,4,5},
   {2,7},
   {5,6},
];
bids = [8,6,5,2,2];


% From Numberjack Tutorial, page 24 (slide 51/175)
% num_items = 4;
% num_bids = 5;
% max_item = 5;
% packages = [
%    {1,2},
%    {1,3},
%    {2,4},
%    {2,3,4},
%    {1}
% ];
% bids = [8,6,5,2,2];


output
[
  "x: " ++ show(x) ++ "\n" ++
  "total: " ++ show(total) 
];