int: M; % length of m
int: N; % length of n

set of int: p = {2,3,5,7};
var int: mP;
array[1..M] of var p: mP_a;
var int: nP;
array[1..N] of var p: nP_a;

var int: mnP;
array[1..M+N] of var p: mnP_a;


% solve satisfy;
solve :: int_search(mP_a ++ nP_a ++ mnP_a ++ [mP, nP, mnP], first_fail, indomain_min, complete) satisfy;

predicate toNum(array[int] of var int: n_a, var int: n_sum) =
          let { int: len = length(n_a) }
          in
          n_sum = sum(i in 1..len) (
            ceil(pow(10.0, int2float(len-i))) * n_a[i]
          )
          /\ forall(i in 1..len) (n_a[i] >= 0)
;


constraint

   toNum(mP_a, mP) 
   /\
   toNum(nP_a, nP) 
   /\
   toNum(mnP_a, mnP) 
   /\
   mP * nP = mnP

;

% output [
%   "mP: ", show(mP),"\n",
%   "nP: ", show(nP),"\n",
%   "mnP: ", show(mnP),"\n",
% ];

output [
   show(mP), " * ", show(nP), " = ", show(mnP), "\n"
];


%
% data 
%
M = 4;
N = 3;