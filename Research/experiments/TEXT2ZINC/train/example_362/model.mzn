include "globals.mzn"; 
int: n = 4;
int: base = 10;
int: rows = base; % 7 steps for n = 4
int: max_val = ceil(pow(int2float(base), int2float(n)))-1; % 9999;
int: min_val = max_val div base;

% The end number(s) for base = 10 and n = 2..9.
% n >= 10 don't work well on a 32-bit machine.
% See http://www.hakank.org/minizinc/kaprekars_constant2.mzn
% for calculating the end number(s) for a base and length n.
%
array[2..10] of set of int: nums = 
 array1d(2..10,
 [ 
 {},                     % 2 none
 {495},                  % 3
 {6174},                 % 4
 {},                     % 5 none
 {549945, 631764},       % 6
 {},                     % 7 none
 {63317664, 97508421},   % 8
 {554999445, 864197532}, % 9
 {6333176664, 9753086421, 9975084201} % 10 % don't work on a 32-bit machine
 % {86431976532},         % 11   
 % {999750842001,997530864201,975330866421,633331766664,555499994445}, % 12
 % {8643319766532}        % 13
 ]);

% decision variables
array[1..rows] of var 0..max_val: x;

% where is the fixpoint (6174 for n=4)? This is the number of iterations. 
% There are pos-1 steps.
var 1..rows: pos; 

predicate reverse(array[int] of var 0..base-1: a, array[int] of var 0..base-1: rev) =
   let { 
      int: len = length(a)
   }
   in
   forall(i in 1..len) (
    rev[i] = a[len-i+1]
   )
;

predicate toNum(array[int] of var 0..base-1: a, var 0..max_val: n, int: base) =
          let { int: len = length(a) }
          in
          n = sum(i in 1..len) (
            ceil(pow(int2float(base), int2float(len-i))) * a[i]
          )
;



% 
% do the Kaprakar procedure
%
predicate kaprekar(var 0..max_val: s, var 0..max_val: t, int: base) =
  let {
     array[1..n] of var 0..base-1: s_num,
     array[1..n] of var 0..base-1: s_ordered,
     array[1..n] of var 0..base-1: s_reverse, 
     var 0..max_val: ord_num,
     var 0..max_val: rev_num
  }
  in
  toNum(s_num, s, base)
  /\
  sort(s_num, s_ordered)
  /\
  reverse(s_ordered, s_reverse)
  /\
  toNum(s_ordered, ord_num, base)
  /\
  toNum(s_reverse,rev_num, base)
  /\
  t = rev_num - ord_num
;


% solve satisfy;
solve :: int_search(x ++ [pos], input_order, indomain_min, complete) satisfy;

% constraint  trace("min_val: " ++ show(min_val) ++ " max_val: " ++ show(max_val) ++ "\n" , 1=1);

constraint

  forall(i in 2..rows) (
     kaprekar(x[i-1], x[i], base)
  )

  % test one number
  /\ x[1] = 3141

  /\
  not(x[1] in nums[n]) % skip the fixpoint numbers
  /\ 
  % get the position
  let {
     var 1..rows: i
   } in
     pos = i
     /\
     x[i] in nums[n]
     /\
     (i > 1 -> x[i-1] != x[i])
   
 
  %/\ % get all cycles of length pos (i.e. pos-1 steps)
  %pos = 2
;

output [

  "x: " ++ show(x) ++ "\n" ++
  "pos: " ++ show(pos) ++ "\n" ++ 
  "start: " ++ show(x[1]) ++ "\n"
]
++
[
  show(x[i]) ++ " "
  | i in 1..fix(pos)
]
++ 
["\n"];