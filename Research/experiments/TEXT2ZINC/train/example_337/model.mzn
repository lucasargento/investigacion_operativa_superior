int: n = 8;
array[1..n] of int: denom = [1, 2, 5, 10, 20, 50, 100, 200]; % in cents
int: s = 4158; % 41.58
array[1..n] of var int: x;
var int: num_coins = sum(i in 1..n) (x[i]);

solve :: int_search(x, smallest, indomain_min, complete) minimize num_coins;
% solve :: int_search(x, smallest, indomain_min, complete) satisfy;

constraint
%   s = 4158
%   /\
   sum(i in 1..n) (x[i]*denom[i]) = s
   /\
   forall(i in 1..n) (
      x[i] >= 0
      /\
      x[i] <= s
   )
   /\
   forall(i, j in 1..n) (
     x[i] = x[j] 
     \/ 
     x[i] = 0 
     \/
     x[j] = 0
   )
;

output
[
  "x: " ++ show(x) ++ "\n" ++
  "num_coins: " ++ show(num_coins)
];