include "alldifferent.mzn";

% Define the variables
var 0..9: A; var 0..9: B; var 0..9: C; var 0..9: D; var 0..9: E; var 0..9: F; var 0..9: G; var 0..9: H; var 0..9: I; var 0..9: J;

% Define the constraints
constraint alldifferent([A, B, C, D, E, F, G, H, I, J]);
constraint A + B + C + D + E + F + G + H + I + J = 45;

% Define the objective function
solve satisfy;

% Output the solution
output ["A=", show(A), " B=", show(B), " C=", show(C), " D=", show(D), " E=", show(E), " F=", show(F), " G=", show(G), " H=", show(H), " I=", show(I), " J=", show(J)];