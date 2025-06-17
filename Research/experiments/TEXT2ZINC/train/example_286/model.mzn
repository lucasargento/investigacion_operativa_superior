include "globals.mzn";

% Define the variables
var 0..9: S; var 0..9: E; var 0..9: N; var 0..9: D; var 0..9: M; var 0..9: O; var 0..9: R; var 0..9: Y;

% Define the constraints
constraint alldifferent([S, E, N, D, M, O, R, Y]);
constraint S != 0;
constraint M != 0;
constraint 1000*S + 100*E + 10*N + D + 1000*M + 100*O + 10*R + E = 10000*M + 1000*O + 100*N + 10*E + Y;

% Define the objective function
solve satisfy;

% Output the solution
output ["S=", show(S), " E=", show(E), " N=", show(N), " D=", show(D), " M=", show(M), " O=", show(O), " R=", show(R), " Y=", show(Y)];