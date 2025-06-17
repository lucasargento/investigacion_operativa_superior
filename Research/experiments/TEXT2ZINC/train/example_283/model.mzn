include "globals.mzn";

% The order of the grid
int: n = 8;

% The marks on the grid
array[1..n] of var 1..n: marks;

% The vectors between the marks
array[1..n, 1..n-1] of var -n+1..n-1: vectors;

% Each row and column contains only one mark
constraint alldifferent(marks);

% The vectors between the marks are all different
constraint forall(i in 1..n)(
  forall(j in 1..n-1)(
    vectors[i,j] = marks[i] - marks[j]
  )
);

constraint forall(i in 1..n)(
  forall(j in 1..n-1)(
    forall(k in j+1..n-1)(
      vectors[i,j] != vectors[i,k]
    )
  )
);

solve satisfy;

output [ "marks = " ++ show(marks) ];