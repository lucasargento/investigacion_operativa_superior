include "globals.mzn";

% The unique integer n
int: n;

% The square
array[1..n, 1..n] of var 1..n*n: square;

% The sums of the rows, columns and diagonals
array[1..2*n+2] of var int: sums;

% All elements in the square are different
constraint alldifferent([square[i,j] | i in 1..n, j in 1..n]);

% The sums of the rows
constraint forall(i in 1..n) (
  sums[i] = sum(j in 1..n) (square[i,j])
);

% The sums of the columns
constraint forall(j in 1..n) (
  sums[n+j] = sum(i in 1..n) (square[i,j])
);

% The sums of the diagonals
constraint sums[2*n+1] = sum(i in 1..n) (square[i,i]);
constraint sums[2*n+2] = sum(i in 1..n) (square[i,n-i+1]);

% The sums form a sequence of consecutive integers
constraint increasing(sums);

% Solve
solve satisfy;

% Output
output [ "square = ", show(square), "\n", "sums = ", show(sums), "\n" ];