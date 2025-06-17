include "globals.mzn";

% Size of the chessboard
int: n = 7;

% Array of variables
array[1..n] of var 0..n-1: queens;

% All elements must be different
constraint alldifferent(queens);

% No two queens are in the same diagonal
constraint forall(i in 1..n)(
  forall(j in i+1..n)(
    abs(queens[i]-queens[j]) != abs(i-j)
  )
);

% Find a solution
solve satisfy;

% Output the solution
output [ "\n" ++ show(queens[i]) | i in 1..n];