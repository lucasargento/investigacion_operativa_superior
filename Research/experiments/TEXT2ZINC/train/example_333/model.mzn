include "globals.mzn"; 

int: n;
array[1..n] of int: numbers;

% decision variables
array[1..n] of var 1..100: x; % the result: numbers in the final positions
array[1..n] of var 1..n: perm; % permutation of numbers for index in x
array[1..n] of var 1..10000: s; % array of the consecutive results
var int: total; % the total

int: max_ops = 4; % number of operations
% int: max_ops = 6;
array[1..n-1] of var 0..max_ops: ops; % the operations

% array[1..max_ops] of string: ops_string = ["+","-","*","/","/","^"];
array[1..max_ops] of string: ops_string = ["+","-","*","/"];

% solve satisfy;
solve :: int_search(ops ++ x ++ s ++ perm, first_fail, indomain_min, complete) satisfy;

%  res = a op b
predicate make_op(var int: a, var int: b, var int: xop, var int: res) =
  (xop = 1 <-> res = a + b)
  /\
  (xop = 2 <-> res = a - b)
  /\
  (xop = 3 <-> res = a * b)
  /\
  (xop = 4 <-> a = res * b) % division 1
  % /\ 
  % (xop = 5 <-> b = res * a) % division 2
  % /\
  % q(xop = 6 <-> res = a * a) % square
;


%
% make the equationx
%
predicate make(array[int] of var int: y, array[int] of var 1..max_ops: xop, var int: res, array[int] of var int: s) =
   let {
     int: len = length(y),
    }
   in
   s[1]=y[1] /\
   forall(i in 1..len-1) (
      make_op(s[i], y[i+1], xop[i], s[i+1])
   )
   /\
   res = s[len]

;

constraint

   % % cf http://en.wikibooks.org/wiki/Puzzles/Arithmetical_puzzles/Four_4s_Equal...
   % numbers = [4,4,4,4]
   % /\

   % perm is a permutation of position in numbers
   % for the position of x
   all_different(perm)
   /\ % get a permutation of numbers
   forall(i in 1..n) (
     x[i] = numbers[perm[i]]
   )
   /\
   make(x, ops, total,s) 
   %/\ total >= 522 
   %/\ total < 600
   % /\ total = 666
   /\ total = 564
;


%
%
%
n = 6;
% numbers = [100, 5, 5, 2, 6, 8]; % same number twice
% numbers = [100, 5, 3, 2, 6, 8];
numbers = [3,5,9,9,10,100];
% n = 4;
% numbers = [4,4,4,4];

output
[
  "x      : " ++ show(x) ++ "\n" ++
  % "perm   : " ++ show(perm) ++ "\n" ++
  "s      : " ++ show(s) ++ "\n" ++
  % "numbers: " ++ show(numbers) ++ "\n" ++
  "total  : " ++ show(total) ++ "\n" ++
  "ops    : " ++ show(ops) ++ "\n" ++ 
  "ops_str: " ++ show([ops_string[fix(ops[i])] | i in 1..n-1]) ++ "\n"
]
++
[ "(" | i in 1..n-1 ]
++
[
  show(x[i]) ++ if i > 1 then ")" else "" endif 
  ++ show(ops_string[fix(ops[i])])
  | i in 1..n-1
] ++ 
[show(x[n]), ")\n"]
++
[ 
  show(s[i]) ++ show(ops_string[fix(ops[i])]) ++ show(x[i+1]) ++ " = " ++ show(s[i+1]) ++ "\n"
  | i in 1..n-1
]
;