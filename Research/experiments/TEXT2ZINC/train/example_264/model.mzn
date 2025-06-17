include "globals.mzn";

% Define the range of numbers
int: n = 8;

% Define the sets A and B
set of int: A = 1..n;
set of int: B = 1..n;

% Define the variables for the elements in sets A and B
array[A] of var 0..1: a;
array[B] of var 0..1: b;

% Define the constraints
constraint forall(i in A)(sum(j in A)(a[j]*j) = sum(j in B)(b[j]*j));
constraint forall(i in A)(sum(j in A)(a[j]*j*j) = sum(j in B)(b[j]*j*j));
constraint sum(i in A)(a[i]) = sum(i in B)(b[i]);

% Ensure that the elements in both sets are different
constraint forall(i in A)(a[i] + b[i] <= 1);

% Solve the problem
solve satisfy;

% Output the solution
output [ "A = ", show([ i | i in A where a[i] = 1 ]), "\n", "B = ", show([ i | i in B where b[i] = 1 ]) ];