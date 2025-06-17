include "globals.mzn"; 

% data
% size of grid
int: n;
% number of 1s and 0s in each row
int: m = n div 2;
% initial grid configuration 
array[1..n, 1..n] of var 0..1: problem;

% decision variables
array[1..n, 1..n] of var 0..1: grid;


% satisfaction
solve satisfy;

% initialize the problem
constraint
  forall(i, j in 1..n) (
    grid[i, j] = problem[i, j]
  );

% equal number of 0s and 1s in each row 
constraint
  forall(i in 1..n) (
    sum([bool2int(grid[i, j] = 0) | j in 1..n]) = m
  );

% equal number of 0s and 1s in each column
constraint
  forall(i in 1..n) (
    sum([bool2int(grid[j, i] = 0) | j in 1..n]) = m
  );

% no more than two of the same values adjacent
constraint
  forall(i in 2..n-1) (
    forall(j in 1..n) (
      (grid[i-1, j] != grid[i, j] \/ grid[i, j] != grid[i+1, j])
      /\
      (grid[j, i-1] != grid[j, i] \/ grid[j, i] != grid[j, i+1])
    )
  );

% no identical row
constraint
  forall(i, j in 1..n where i < j) (
    exists(k in 1..n) ( grid[i, k] != grid[j, k] )
  );

% no identical column
constraint
  forall(i, j in 1..n where i < j) (
    exists(k in 1..n) ( grid[k, i] != grid[k, j] )
  );  

% output
output [
   if j = 1 then "\n" else " " endif ++
     show(grid[i,j])
   | i,j in 1..n
];