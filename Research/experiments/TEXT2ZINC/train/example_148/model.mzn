include "globals.mzn"; 

int: n = 11;

% decision variables
array[1..n,1..n] of var 0..1: x;
array[1..n] of var 1..n: degrees;


% solve satisfy;
solve :: int_search(degrees, first_fail, indomain_split, complete) satisfy;

constraint
  forall(i,j,k,l in 1..n where i < j /\ j < k /\ k < l) (
     x[i,j] + x[i,k] + x[i,l] + x[j,k] + x[j,l] + x[k,l] <= 4
  )
  /\
  forall(i in 1..n) (
     degrees[i] = sum([x[i,j] | j in 1..n])
     /\ degrees[i] mod 3 = 0
     % no loops
     /\ x[i,i] = 0
  ) 
  /\ % undirected graph
  forall(i,j in 1..n) (
    x[i,j] = x[j,i]
  )
  /\ sum(degrees) mod 12 = 0

  % symmetry breaking
  /\ decreasing(degrees)
  /\ lex2(x)
;

output 
[ "degrees: ", show(degrees), "\n"]
% ++
% [
%   if j = 1 then "\n" else " " endif ++
%     show(x[i,j])
%   | i,j in 1..n
% ]
;