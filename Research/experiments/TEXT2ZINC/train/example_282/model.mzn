include "globals.mzn";

% Size of the chess board
int: n = 8;

% Number of queens
int: m = 8;

% Variables
array[1..n] of var 1..n: Q;
array[1..n] of var 1..n: K;

% Constraints
constraint alldifferent(Q);

% Each queen is in a different row/column
constraint forall(i in 1..n)(forall(j in i+1..n)(Q[i] != Q[j] /\ abs(Q[i]-Q[j]) != abs(i-j)));

% Knights form a cycle
constraint forall(i in 1..n-1)(abs(K[i+1]-K[i]) = 2 \/ abs(K[i+1]-K[i]) = 1);
constraint abs(K[n]-K[1]) = 2 \/ abs(K[n]-K[1]) = 1;

% Queens and knights are not in the same position
constraint forall(i in 1..n)(Q[i] != K[i]);

% Solve
solve satisfy;

% Output
output [ "Q: " ++ show(Q) ++ "\n" ++ "K: " ++ show(K) ];