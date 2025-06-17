include "globals.mzn";

% Define the order of the instance
int: n = 5; % odd positive integer
int: m = (n-1) div 2;

% Define the 2cc Hadamard matrix
array[1..n, 1..n] of var -1..1: H;

% Define the Legendre pairs
array[1..n, 1..n] of var -1..1: L;

% Quadratic constraints
constraint forall(i in 1..m)(
  sum(j in 1..n)(H[i,j]*H[i+1,j]) = 0
);

% Linear constraints
constraint sum(i in 1..n, j in 1..n)(H[i,j]) = 0;
constraint sum(i in 1..n, j in 1..n)(L[i,j]) = 0;

% The Legendre pairs are derived from the Hadamard matrix
constraint forall(i in 1..n, j in 1..n)(
  L[i,j] = H[i,j]*H[(i+j-1) mod n + 1, (j+i-1) mod n + 1]
);

solve satisfy;

output [ "H = ", show(H), "\n", "L = ", show(L), "\n" ];