include "globals.mzn";

% Order of the quasigroup
int: n = 4;

% Quasigroup
array[1..n, 1..n] of var 1..n: Q;

% Each element occurs once in every row and column
constraint forall(i in 1..n)(alldifferent(row(Q, i)));
constraint forall(i in 1..n)(alldifferent(col(Q, i)));

% Quasigroup properties
constraint forall(a in 1..n, b in 1..n)(Q[Q[a,b], Q[b,a]] = a);
constraint forall(a in 1..n, b in 1..n)(Q[Q[Q[b,a],b],b] = a);
constraint forall(a in 1..n, b in 1..n)(Q[Q[a,b],b] = Q[a, Q[a,b]]);

% Quasigroup is idempotent
constraint forall(a in 1..n)(Q[a,a] = a);

solve satisfy;

output ["Quasigroup:\n"] ++ [show(Q[i,j]) ++ " " | i in 1..n, j in 1..n];