include "globals.mzn"; 


int: k = 2; % number of dimensions
int: num_shapes = 8; % number of sids
int: num_boxes = 20; % number of rectangles

% lengths (the l parameter)
array[1..num_boxes, 1..k] of int: rect_size = 
  array2d(1..num_boxes, 1..k,
  [
     % sid 1 
     2,1,  % 1 
     1,2,  % 2
     3,1,  % 3

     % % sid 2
     3,1,  % 4
     1,3,  % 5
     1,1,  % 6

     % % sid 3
     2,1,  % 7
     1,2,  % 8
     3,1,  % 9

     % % sid 4
     3,1,  % 10
     1,1,  % 11
     1,3,  % 12

     % sid 5
     2,1,  % 13
     1,1,  % 14
     2,1,  % 15

     % % sid 6
     3,1,  % 16
     1,1,  % 17
     1,1,  % 18

     % sid 7
     3,2,  % 19
 
     % sid 8
     2,3,  % 20

  ]);

% the t parameter
array[1..num_boxes,1..k] of int: rect_offset = 
array2d(1..num_boxes, 1..k,
[
 % sid 1: 
 0,0,
 0,1,
 1,2,

 % % sid 2:
   
 0,0,
 0,1,
 2,1,

 % sid 3:

 0,0,
 1,1,
 -2,2, % note: negative offset!
 
 % sid 4:

 0,0,
 0,1,
 2,1,

 % sid 5:

 0,0,
 1,1,
 0,2,

 % sid 6:

 0,0,
 0,1,
 2,1,

 % sid 7:

 0,0,

 % sid 8:

 0,0,

]);

array[1..num_shapes] of set of int: shape = 
 [1..3,   % sid 1  for shape A
  4..6,   % sid 2  for shape A
  7..9,   % sid 3  for shape A
  10..12, % sid 4  for shape A
  13..15, % sid 5  for shape B
  16..18, % sid 6  for shape B
  {19},   % sid 7  for shape C
  {20}    % sid 8  for shape C
];

% shape groups (objects), i.e. shape A, B, and C
int: num_shape_groups = 3;
array[1..num_shape_groups] of set of int: shape_groups = [1..4,5..6,7..8];


% decision variables
array[1..num_shape_groups, 1..k] of var 0..5: x;
array[1..num_shape_groups] of var 1..num_shapes: kind;
array[1..k] of var 0..10: lower;
array[1..k] of var 0..10: upper;

var 0..sum([ub(upper[i]) | i in 1..k]): sum_upper = sum(upper);

% solve satisfy;
% solve minimize sum_upper;
solve :: int_search(kind ++ [x[i,j] | i in 1..num_shape_groups, j in 1..k], first_fail, indomain_split, complete) minimize sum_upper;

constraint

  % all_different(kind) 
  % /\

  % geost(k, rect_size, rect_offset, shape, x, kind) 
  geost_bb(k, rect_size, rect_offset, shape, x, kind,lower,upper) 

  /\ % ensure that we pick one shape variant from 
     % each shape group (A, B, and C)
  forall(i in 1..num_shape_groups) (
     kind[i] in shape_groups[i]
  )

  % /\ sum_upper = 9
;

output [
  "x: ", show(x), "\n",
  "kind:  ", show(kind), "\n",
  "lower: ", show(lower), "\n",
  "upper: ", show(upper), "\n",
  "sum_upper: ", show(sum_upper), "\n",
]
++
[
  if j = 1 then "\n" else " " endif ++
    if j = 1 then "kind " ++ show(kind[i]) ++ ": " else "" endif ++
      show(x[i,j]) 
| i in 1..num_shape_groups, j in 1..k
]
;