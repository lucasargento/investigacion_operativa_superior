include "globals.mzn"; 

int: n = 9;
int: target = 100; % the target number
int: max_num = 999; % maximum number to be represented in y
set of 1..n: d = 1..n;

% decision variables
array[d] of var d: x; % the digit representation
array[d] of var 0..max_num: y; % the numbers to use
array[1..n] of var {-1,1}: ops; % array of operations
array[d] of var 0..max_num: s; % the cumulative sum of operations

% convert between an array and a (decimal) number
predicate toNum(array[int] of var int: a, var int: n,  float: base) =
   let { int: len = length(a) } in
   n = sum(i in 1..len) (
      ceil(pow(base, int2float(len-i))) * a[i]
   )
   /\ forall(i in 1..len) (a[i] >= 0)
;

% convert between an array and a (decimal) number, but reverse the order
% in the array a
predicate toNum_reverse(array[int] of var int: a, var int: n,  float: base) =
   let { int: len = length(a) } in
   n = sum(i in 1..len) (
      ceil(pow(base, int2float(len-i))) * a[len-i+1]
   )
   /\ forall(i in 1..len) (a[i] >= 0)
;

% the element e is in the array a
predicate contains(var int: e, array[int] of var int: a) =
   exists(i in 1..length(a)) ( a[i] = e )
;

%
% decreasing: cf the built in increasing predicate
%
predicate decreasing_me(array[int] of var int: x) = 
    forall(i in 2..length(x)) ( x[i-1] >= x[i]  )
;


%
% variable selection occurrence and indomain seems to be best for Gecode/fz
%
solve :: int_search(ops ++ s ++ x ++ y, first_fail, indomain_min, complete) satisfy;
% solve :: int_search(ops ++ s ++ x ++ y, "occurrence", "indomain_min", "complete") minimize sum(i in d) (bool2int(y[i] > 0));

constraint

  %% increasing(x)
  decreasing_me(x)
  /\
  %% x[1] = 1 % increasing
  x[1] = n % decreasing
  /\
  forall(i in d) (
     (not(contains(i, x)) <-> y[i] = 0)
     /\
     (contains(i,x) <->
        %
        % from the sequence of identical digits in x we convert 
        % to a number in y
        % 
        exists(j, k in d where j <= k) (
           forall(a in j..k) (   
             x[a] = i
           )  
           /\ % check the range
           % increasing
           %% if k < n then x[k+1] > i /\ j = i else true endif % increasing
           %% /\
           %% if j > 1 then x[j-1] < i /\ j = i else true endif % increasing
           %% /\
           %% toNum([a | a in j..k], y[i], 10.0) % increasing

           % decreasing
           if k < n then x[k+1] < i /\ j = (n-i+1) else true endif % decreasing
           /\
           if j > 1 then x[j-1] > i /\ j = (n-i+1) else true endif % decreasing
           /\ 
           toNum_reverse([a | a in j..k], y[i], 10.0) % decreasing
      )
    )
  )
  /\
  %
  % and now we check the addition / subtraction
  % (same for both increasing and decreasing)
  % 
  (
     (s[1] = y[1] /\ ops[1] = 1)
     \/
     (s[1] = -y[1] /\ ops[1] = -1)
  )
  /\ % 0 in y is considered a "+"
  forall(i in d) (
    y[i] = 0 -> ops[i] = 1
  )
  /\ % either + or -, and record the operation i ops
  forall(i in 2..n) (
    (s[i] = s[i-1] + y[i] /\ ops[i] = 1)
    \/
    (s[i] = s[i-1] - y[i] /\ ops[i] = -1)
  )
  /\
  s[n] = target
;

output 
[
  "x  : ", show(x), "\n",
  "y  : ", show(y), "\n",
  "ops: ", show(ops), "\n",
  "s  : ", show(s), "\n",
  "s[n]: ", show(s[n]), "\n",
] ++ 
[ 
  "sol: " 
]
++
[
 if fix(y[i]) > 0 then
   if fix(ops[i]) = 1 then 
     "+" else 
     "-" endif 
     ++ show(y[i])
 else 
   "" 
 endif
  | i in 1..n
] ++ 
["\n"];