include "globals.mzn";

% Bucket capacities
int: c1 = 8; int: c2 = 5; int: c3 = 3;

% Goal quantities
int: g1 = 4; int: g2 = 4; int: g3 = 0;

% Horizon
int: h = 6;

% Decision variables
array[1..h, 1..3] of var 0..c1: x;

% Initial state
constraint forall(i in 1..3)(x[1,i] = if i = 1 then c1 else 0 endif);

% Goal state
constraint forall(i in 1..3)(x[h,i] = if i = 1 then g1 else if i = 2 then g2 else g3 endif endif);

% Transitions
constraint forall(t in 1..h-1, i in 1..3, j in 1..3 where i != j)(
  x[t+1,i] = x[t,i] - min(x[t,i], c3 - x[t,3]) /\ x[t+1,j] = x[t,j] + min(x[t,i], c3 - x[t,3])
);

% Solve
solve minimize h;

% Output
output [ "Transfer " ++ show(t) ++ ": " ++ show(x[t,1]) ++ ", " ++ show(x[t,2]) ++ ", " ++ show(x[t,3]) ++ "\n" | t in 1..h];