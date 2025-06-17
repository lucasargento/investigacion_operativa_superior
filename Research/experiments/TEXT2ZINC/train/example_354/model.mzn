int: n = 5;

var 10000..99999: p;
array[1..n] of var 0..9: x;


predicate is_prime(var int: x) =
   x > 1 
   /\
   forall(i in 2..1+ceil(sqrt(int2float(ub(x))))) ( 
        (i < x) -> (x mod i > 0)
   )
;

% channel array a <-> var int n
predicate toNum10(array[int] of var int: a, var int: n) =
          let { int: len = length(a) }
          in
          n = sum(i in 1..len) (
            ceil(pow(10.0, int2float(len-i))) * a[i]
          )
          /\ forall(i in 1..len) (a[i] >= 0)
;


% solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   is_prime(p) /\ toNum10(x, p)
;

% """
% A limerick prime has to have the form AABBA where A is an 
% odd digit and B is any digit other than A. 
% """
constraint
   x[1] mod 2 = 1
   /\ % AA..A
   x[1] = x[2] /\ x[1] = x[5]
   /\ % ..BB.
   x[3] = x[4]
   /\ 
   x[1] != x[3]
;

output [
  "p: " ++ show(p) ++ "\n" ++
  "x: " ++ show(x)
]
 ++ ["\n"]
;