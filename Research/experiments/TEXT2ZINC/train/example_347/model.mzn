include "globals.mzn"; 

int: r;                        % Number of rows in the puzzle
int: c;                        % Number of columns in the puzzle
array[1..r, 1..c] of int: puzzle;  % The puzzle grid with fixed tiles

array[1..r, 1..c] of var 1..r*c: grid;  % Variable representing the puzzle grid

solve satisfy;

% Constraints

% Place all integers from 1 to r*c uniquely
constraint all_different([grid[i,j] | i in 1..r, j in 1..c]) :: domain;

% Place the fixed tiles from the puzzle into the grid
constraint forall(i in 1..r, j in 1..c) (
    puzzle[i,j] > 0 -> 
        grid[i,j] = puzzle[i,j]
);

% Constraint 3: Ensure that each number k from 1 to r*c-1 is followed by k+1 in a valid move
constraint forall(k in 1..r*c-1) (
    let {
        var 1..r: i;           % Row index of k
        var 1..c: j;           % Column index of k
        var {-1,0,1}: a;       % Change in row for next number
        var {-1,0,1}: b        % Change in column for next number
    }
    in
    k = grid[i, j] % Fix the current number k
    /\
    i+a >= 1 /\ j+b >= 1    % Ensure the next position is within bounds
    /\
    i+a <= r /\ j+b <= c
    /\
    not(a = 0 /\ b = 0)     % Ensure movement is not stagnant
    /\
    k + 1 = grid[i+a, j+b]     % Ensure the next number is k + 1
);

% output
output 
[
  if j = 1 then "\n" else " " endif ++
    show_int(3, grid[i,j])
  | i in 1..r, j in 1..c

];