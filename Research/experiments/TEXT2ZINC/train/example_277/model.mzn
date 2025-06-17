include "globals.mzn";

% Define the variables
var 0..9: S; var 0..9: E; var 0..9: N; var 0..9: D;
var 0..9: M; var 0..9: O; var 0..9: R; var 0..9: Y;

% All letters must represent different digits
constraint alldifferent([S, E, N, D, M, O, R, Y]);

% The sum of the first two words must equal the third word
constraint 1000*S + 100*E + 10*N + D + 1000*M + 100*O + 10*R + E = 10000*M + 1000*O + 100*N + 10*E + Y;

% The leading digits cannot be zero
constraint S > 0;
constraint M > 0;

solve satisfy;

output ["S = ", show(S), "\n", "E = ", show(E), "\n", "N = ", show(N), "\n", "D = ", show(D), "\n",
        "M = ", show(M), "\n", "O = ", show(O), "\n", "R = ", show(R), "\n", "Y = ", show(Y), "\n"];