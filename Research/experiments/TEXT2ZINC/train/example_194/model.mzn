include "globals.mzn"; 

int: m = 13;
int: n = m*2;

array[0..1] of string: s = array1d(0..1, ["[","]"]);

% For cumulative (c):
% +1 if x[i] = "["
% -1 if x[i] = "]"
array[0..1] of int: t = array1d(0..1, [1, -1]);  

% 0: "[", 1: "]"
array[1..n] of var 0..1: x;
array[1..n] of var 0..n: c; % counter (cumulative)

% solve satisfy;
solve :: int_search(
        x ++ c, 
        first_fail, 
        indomain_split, 
        complete) 
    satisfy;


constraint
  x[1] = 0 /\ c[1] = 1  % start

  /\ % cumulative
  forall(i in 2..n) (
     c[i] = c[i-1] + t[x[i]]
  )
  /\ x[n] = 1 
  /\ c[n] = 0 % end

  % Redundant constraint: This might make it faster (but it don't)
  % /\ sum(x) = m
;

output 
[
  "m: " ++ show(m) ++ " n: " ++ show(n) ++ "\n" ++
  "x: " ++ show(x) ++ "\n" ++
  "c: " ++ show(c) ++ "\n"
]
++
[
  show(s[fix(x[i])]) 
  | i in 1..n
]
++ ["\n"]
;