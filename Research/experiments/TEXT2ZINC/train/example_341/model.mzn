include "globals.mzn"; 
int: n = 4;
set of int: Cube = 1..n;
int: num_words = 12;
int: m = 24;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;
int: H = 8;
int: I = 9;
int: J = 10;
int: K = 11;
int: L = 12;
int: M = 13;
int: N = 14;
int: O = 15;
int: P = 16;
int: R = 17;
int: S = 18;
int: T = 19;
int: U = 20;
int: V = 21;
int: W = 22;
int: X = 23;
int: Y = 24;

array[1..m] of string: alpha = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
                                "N","O","P","R","S","T","U","V","W","X","Y"];

array[1..num_words, 1..n] of int: words = array2d(1..num_words, 1..n,
  [
   B,A,K,E,
   O,N,Y,X,
   E,C,H,O,
   O,V,A,L,
   G,I,R,D,
   S,M,U,G,
   J,U,M,P,
   T,O,R,N,
   L,U,C,K,
   V,I,N,Y,
   L,U,S,H,
   W,R,A,P
  ]);

% decision variable
array[1..m] of var Cube: dice;

solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
  % the letters in a word must be on a different die
  forall(i in 1..num_words) (
    alldifferent([dice[words[i,j]] | j in 1..n])
  )

  /\
  % there must be exactly 6 letters of each die
  % forall(i in 1..n) (
  %   sum(j in 1..m) (bool2int(dice[j] = i)) = 6
  % )
  % /\
  global_cardinality(dice, [i | i in 1..n], [6 | i in 1..n])

  % symmetry breaking (first word is placed)
  % /\ dice[B] = 1 /\ dice[A] = 2 /\ dice[K] = 3 /\ dice[E] = 4
  /\
  % symmetry breaking
  dice[ 1] <= dice[ 7] /\
  dice[ 7] <= dice[13] % /\
  % dice[13] <= dice[19]

;




output [
  "dice: " ++ show(dice) ++ "\n"
]
++
[  
    if j = 1 then "\nDice" ++ show(i) ++ ": " else "" endif ++
    if fix(dice[j]) = i then
      show(alpha[j]) ++ " "
    else "" endif
 
  | i in 1..n, j in 1..m
];