int: tea = 3;

set of 1..tea: T = 1..tea;

array[T] of int: price;
array[T] of var int: x;
var int: minexp = sum(i in T) (x[i]*price[i]);  % total price

% minimize total prize
% solve minimize minexp;
solve :: int_search(x, first_fail, indomain_min, complete) minimize minexp;

constraint
  forall(i in T) (x[i] >= 0)
  /\
  sum(i in T) (price[i]*x[i]) = 570 % 20 pound * 2s 4 1/2d = 20 * (24+4+1/2) = 570
  /\
  sum(i in T) (x[i]) = 20 % twenty pound

; 

price = [30, 27, 21];


output
[
  "x: " ++ show(x) ++ "\n" ++
  "minexp: " ++ show(minexp) ++ "\n"
];