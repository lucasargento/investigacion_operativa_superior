include "globals.mzn";

% Define the variables
var 1..6: U; var 1..6: D; var 1..6: L; var 1..6: R; var 1..6: F; var 1..6: B;
array[1..9] of var 1..6: up; array[1..9] of var 1..6: down; array[1..9] of var 1..6: left; array[1..9] of var 1..6: right; array[1..9] of var 1..6: front; array[1..9] of var 1..6: back;

% Define the constraints
constraint forall(i in 1..9)(up[i] = U);
constraint forall(i in 1..9)(down[i] = D);
constraint forall(i in 1..9)(left[i] = L);
constraint forall(i in 1..9)(right[i] = R);
constraint forall(i in 1..9)(front[i] = F);
constraint forall(i in 1..9)(back[i] = B);

% Define the objective function
solve satisfy;

% Output the solution
output ["U: " ++ show(U), "D: " ++ show(D), "L: " ++ show(L), "R: " ++ show(R), "F: " ++ show(F), "B: " ++ show(B)];