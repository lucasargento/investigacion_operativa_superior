include "globals.mzn";

% Number of balls
int: n = 5;

% Number of boxes
int: d = 4;

% Array to hold the box number for each ball
array[1..n] of var 1..d: box;

% Constraint: For any three balls (x, y, z) where x + y = z, all three balls are not placed in the same box
constraint forall(i in 1..n, j in i+1..n, k in j+1..n) (
  if i + j = k then
    box[i] != box[j] \/ box[i] != box[k] \/ box[j] != box[k]
  endif
);

% NValues variant: The number of distinct values (or labels) in each box is equal to the total number of boxes
constraint forall(i in 1..d) (
  sum(j in 1..n) (box[j] = i) = d
);

% AllDifferent variant: All balls in each box have different labels
constraint forall(i in 1..d) (
  alldifferent([box[j] | j in 1..n where box[j] = i])
);

solve satisfy;

output ["Box for ball " ++ show(i) ++ ": " ++ show(box[i]) ++ "\n" | i in 1..n];