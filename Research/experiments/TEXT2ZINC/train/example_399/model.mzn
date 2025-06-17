include "globals.mzn";

set of int: xrange = 1..99;
var xrange: A;
var xrange: B;
var xrange: C;
var xrange: D;
var xrange: E;
var xrange: F;
var xrange: G;
var xrange: H;
var xrange: I;
% var xrange: J;
var xrange: K;
array[1..10] of var xrange: LD = [A,B,C,D,E,F,G,H,I,K];

% Predicate to simplify the constraint section
predicate s(var int: X1, var int: X2, var int: Y1, var int: Y2 ) =
   X1*X1 + X2*X2  = Y1*Y1 + Y2*Y2
;

% solve satisfy;
solve :: int_search(LD, first_fail, indomain_min, complete) satisfy;


constraint
   all_different(LD) /\
   A = 16 /\
   B = 2 /\
   F = 8 /\
   G = 14 /\

   s(A, B, F, G) /\
   s(B, C, G, H) /\
   s(C, D, H, I) /\
   s(D, E, I, K) /\
   s(E, F, K, A)
;


output [
   show(LD), "\n",
];