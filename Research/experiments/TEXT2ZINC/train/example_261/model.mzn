include "globals.mzn";

% Define the size of the board
int: n = 8;

% Define the variables
array[1..n, 1..n] of var 0..2: board;

% Define the number of queens
var 0..n: queens;

% The number of black and white queens must be equal
constraint sum(i in 1..n, j in 1..n)(board[i,j] = 1) = queens;
constraint sum(i in 1..n, j in 1..n)(board[i,j] = 2) = queens;

% No queen is under attack from an opposing queen
constraint forall(i in 1..n, j in 1..n) (
  if board[i,j] = 1 then
    forall(k in (i+1)..n)(board[k,j] != 2) /\
    forall(k in (j+1)..n)(board[i,k] != 2) /\
    forall(k in 1..min(n-i,n-j))(board[i+k,j+k] != 2)
  elseif board[i,j] = 2 then
    forall(k in (i+1)..n)(board[k,j] != 1) /\
    forall(k in (j+1)..n)(board[i,k] != 1) /\
    forall(k in 1..min(n-i,n-j))(board[i+k,j+k] != 1)
  else
    true
  endif
);

% Maximize the number of queens
solve maximize queens;

% Output the solution
output [ if fix(board[i,j]) = 1 then "B" else if fix(board[i,j]) = 2 then "W" else "_" endif endif | i in 1..n, j in 1..n];