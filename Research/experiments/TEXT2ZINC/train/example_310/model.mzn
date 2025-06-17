int: m = 3;    % dealers
int: n = 2;    % prices

set of 1..m: M = 1..m;
set of 1..n: N = 1..n;
set of 2..m: Q = 2..m;

array[M] of int: nsold;  % total number sold by each dealer

array[M,N] of var int: x; % number sold by dealer i at price j
array[N] of var 1..10: p; % price j (i.e. first and second prices)

solve satisfy;

constraint
      forall(i in M, j in N) (
          x[i,j] <= nsold[i] /\
          x[i,j] >= 0
      )
      /\
      forall(i in M) (
        nsold[i] = sum (j in N) (x[i,j])
      )
      /\
      forall(k in Q) (
         sum(j in N) ( p[j] * x[1,j] ) = sum(j in N) ( p[j] * x[k,j] )
      )
      /\
      p[2] >= p[1]+1
;

nsold =  [10, 25, 30];

output [
  "nsold: ", show(nsold), "\n",
  "p:     ", show(p)
] ++
[
   if j = 1 then "\n" else " " endif ++
    show(x[i,j])
   | i in M, j in N
] ++ ["\n"]

;