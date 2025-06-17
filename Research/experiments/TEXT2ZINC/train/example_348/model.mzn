include "globals.mzn"; 

% Decision variables
int: num_letters = 26; % number of letters 
set of int: LETTERS = 1..num_letters; % set of letters

var LETTERS: A;
var LETTERS: B;
var LETTERS: C;
var LETTERS: D;
var LETTERS: E;
var LETTERS: F;
var LETTERS: G;
var LETTERS: H;
var LETTERS: I;
var LETTERS: J;
var LETTERS: K;
var LETTERS: L;
var LETTERS: M;
var LETTERS: N;
var LETTERS: O;
var LETTERS: P;
var LETTERS: Q;
var LETTERS: R;
var LETTERS: S;
var LETTERS: T;
var LETTERS: U;
var LETTERS: V;
var LETTERS: W;
var LETTERS: X;
var LETTERS: Y;
var LETTERS: Z;

array[1..num_letters] of var LETTERS: all_letters = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z];

% data from problem statements
int: BALLET     =  45;
int: CELLO      =  43;
int: CONCERT    =  74;
int: FLUTE      =  30;
int: FUGUE      =  50;
int: GLEE       =  66;
int: JAZZ       =  58;
int: LYRE       =  47;
int: OBOE       =  53;
int: OPERA      =  65;
int: POLKA      =  59;
int: QUARTET    =  50;
int: SAXOPHONE  = 134;
int: SCALE      =  51;
int: SOLO       =  37;
int: SONG       =  61;
int: SOPRANO    =  82;
int: THEME      =  72;
int: VIOLIN     = 100;
int: WALTZ      =  34;

% all different constraint
constraint all_different(all_letters);

% constraints for each of the words
constraint sum([B, A, L, L, E, T]) = BALLET;
constraint sum([C, E, L, L, O]) = CELLO;
constraint sum([C, O, N, C, E, R, T]) = CONCERT;
constraint sum([F, L, U, T, E]) = FLUTE;
constraint sum([F, U, G, U, E]) = FUGUE;
constraint sum([G, L, E, E]) = GLEE;
constraint sum([J, A, Z, Z]) = JAZZ;
constraint sum([L, Y, R, E]) = LYRE;
constraint sum([O, B, O, E]) = OBOE;
constraint sum([O, P, E, R, A]) = OPERA;
constraint sum([P, O, L, K, A]) = POLKA;
constraint sum([Q, U, A, R, T, E, T]) = QUARTET;
constraint sum([S, A, X, O, P, H, O, N, E]) = SAXOPHONE;
constraint sum([S, C, A, L, E]) = SCALE;
constraint sum([S, O, L, O]) = SOLO;
constraint sum([S, O, N, G]) = SONG;
constraint sum([S, O, P, R, A, N, O]) = SOPRANO;
constraint sum([T, H, E, M, E]) = THEME;
constraint sum([V, I, O, L, I, N]) = VIOLIN;
constraint sum([W, A, L, T, Z]) = WALTZ;

% satisfaction
solve satisfy;

% output as json
output [
  "{\n",
  "  \"A\": ", show(A), ",\n",
  "  \"B\": ", show(B), ",\n",
  "  \"C\": ", show(C), ",\n",
  "  \"D\": ", show(D), ",\n",
  "  \"E\": ", show(E), ",\n",
  "  \"F\": ", show(F), ",\n",
  "  \"G\": ", show(G), ",\n",
  "  \"H\": ", show(H), ",\n",
  "  \"I\": ", show(I), ",\n",
  "  \"J\": ", show(J), ",\n",
  "  \"K\": ", show(K), ",\n",
  "  \"L\": ", show(L), ",\n",
  "  \"M\": ", show(M), ",\n",
  "  \"N\": ", show(N), ",\n",
  "  \"O\": ", show(O), ",\n",
  "  \"P\": ", show(P), ",\n",
  "  \"Q\": ", show(Q), ",\n",
  "  \"R\": ", show(R), ",\n",
  "  \"S\": ", show(S), ",\n",
  "  \"T\": ", show(T), ",\n",
  "  \"U\": ", show(U), ",\n",
  "  \"V\": ", show(V), ",\n",
  "  \"W\": ", show(W), ",\n",
  "  \"X\": ", show(X), ",\n",
  "  \"Y\": ", show(Y), ",\n",
  "  \"Z\": ", show(Z), "\n",
  "}\n"
];