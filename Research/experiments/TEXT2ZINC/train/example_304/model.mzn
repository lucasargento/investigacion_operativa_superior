int: m = 5;    % days
set of int: M = 1..m;
set of int: Q = 2..m;
array[M] of int: cost;  % cost of books

array[M, M] of var 0..1: x; % x[i,j]=1 if book i bought on day j, 0 otherwise
array[M] of var 0..100: t; % total cost of books on day j

var 0.0..200.0: totcost = int2float(sum(i in M) (cost[i])) - sum(k in Q) (0.001*int2float(t[k-1])*int2float(t[k]));

solve :: int_search([x[i,j] | i, j in M], first_fail, indomain_min, complete) minimize totcost;
% solve minimize totcost;


constraint
  forall(j in M) (
        t[j] = sum(i in M) (cost[i]*x[i,j])
  )

  /\
  forall(i in M) (
        sum(j in M) (x[i,j]) = 1
  )

;

output 
[ 
  "t: ", show(t), "\n",
  "totcost: ", show(totcost)
] ++
[
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i,j in M
];

%
% data
%
cost = [10, 20, 30, 40, 50];