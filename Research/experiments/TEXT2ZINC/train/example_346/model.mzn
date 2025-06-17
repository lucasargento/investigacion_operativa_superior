include "globals.mzn";

% Variables representing the value of each letter
var 0..9: S;  % S must be between 0 and 9
var 0..9: E;  % E must be between 0 and 9
var 0..9: N;  % N must be between 0 and 9
var 0..9: D;  % D must be between 0 and 9
var 0..9: M;  % M must be between 0 and 9
var 0..9: O;  % O must be between 0 and 9
var 0..9: R;  % R must be between 0 and 9
var 0..9: Y;  % Y must be between 0 and 9

% Variables for values carried over in addition
var 0..9: c1; % Carry over from first addition
var 0..9: c2; % Carry over from second addition
var 0..9: c3; % Carry over from third addition
var 0..9: c4; % Carry over from fourth addition

% Array of all letters
array[1..8] of var int: fd = [S, E, N, D, M, O, R, Y];

% Values assigned to each letter must be distinct
constraint all_different(fd);

% Constraints for the addition problem
constraint D + E = 10 * c1 + Y;       % Units column addition
constraint c1 + N + R == 10 * c2 + E;  % Tens column addition
constraint c2 + E + O == 10 * c3 + N;  % Hundreds column addition
constraint c3 + S + M == 10 * c4 + O;  % Thousands column addition
constraint c4 = M;                    % Carry over from thousands column equals M

% S and M must not be equal to zero (they are the leading digits)
constraint S >= 1;
constraint M >= 1;

% Solve the problem by finding values that satisfy all constraints
solve satisfy;

% Output the solution
output [
   "S:", show(S), " E:", show(E), " N:", show(N), " D:", show(D),
   " M:", show(M), " O:", show(O), " R:", show(R), " Y:", show(Y),
   "\n\n",

   "    ", show(S), show(E), show(N), show(D), "\n",
   " +  ", show(M), show(O), show(R), show(E), "\n",
   " = ", show(M), show(O), show(N), show(E), show(Y), "\n"
];