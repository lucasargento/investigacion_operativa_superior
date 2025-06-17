include "globals.mzn";

% Define the variables
var 1..4: A; var 1..4: B; var 1..4: C; var 1..4: D;
var 1..4: E; var 1..4: F; var 1..4: G; var 1..4: H;
var 1..4: I; var 1..4: J; var 1..4: K; var 1..4: L;
var 1..4: M; var 1..4: N; var 1..4: O; var 1..4: P;

% Define the constraints
constraint alldifferent([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]);
constraint A + B + C + D = 10;
constraint E + F + G + H = 10;
constraint I + J + K + L = 10;
constraint M + N + O + P = 10;
constraint A + E + I + M = 10;
constraint B + F + J + N = 10;
constraint C + G + K + O = 10;
constraint D + H + L + P = 10;

% Define the objective function
solve satisfy;

% Output the solution
output ["A = ", show(A), "\n", "B = ", show(B), "\n", "C = ", show(C), "\n", "D = ", show(D), "\n",
        "E = ", show(E), "\n", "F = ", show(F), "\n", "G = ", show(G), "\n", "H = ", show(H), "\n",
        "I = ", show(I), "\n", "J = ", show(J), "\n", "K = ", show(K), "\n", "L = ", show(L), "\n",
        "M = ", show(M), "\n", "N = ", show(N), "\n", "O = ", show(O), "\n", "P = ", show(P), "\n"];