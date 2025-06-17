include "globals.mzn";

% Parameters
int: v; % number of objects
int: b; % number of blocks
int: k; % number of distinct objects per block
int: r; % each object occurs in exactly r different blocks
int: l; % every two distinct objects occur together in exactly l blocks

% Decision variable
array[1..v, 1..b] of var 0..1: X;

% Constraints
constraint forall(i in 1..v)(sum(j in 1..b)(X[i,j]) = r);
constraint forall(j in 1..b)(sum(i in 1..v)(X[i,j]) = k);
constraint forall(i in 1..v-1, j in i+1..v)(sum(k in 1..b)(X[i,k]*X[j,k]) = l);

% Solve
solve satisfy;

% Output
output [ if fix(X[i,j]) = 1 then "1 " else "0 " endif | i in 1..v, j in 1..b];