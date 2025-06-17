int: n = 4;
int: r = 1; % red
int: ry = 2; % red-yellow
int: g = 3; % green
int: y = 4; % yellow

set of int: Cars = {r,ry,g,y};
set of int: Pedestrians = {r,g};

array[1..4, 1..4] of Cars: allowed;

array[1..n] of var Cars: V; % ;
array[1..n] of var Pedestrians: P; %;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

% solve satisfy;
solve :: int_search(V ++ P, first_fail, indomain_min, complete) satisfy;

constraint
 forall(i in 1..n, j in 1..n where j = (1+i) mod 4)  (
   exists(a in 1..4) (
      cp1d([V[i], P[i], V[j], P[j]], [allowed[a,k] | k in 1..4])
   )
 )
;


allowed = array2d(1..4, 1..4, 
[
 r,r,g,g, 
 ry,r,y,r, 
 g,g,r,r, 
 y,r,ry,r
]);


output [
  show(V[i]) ++ " " ++ show(P[i]) ++ " "
  | i in 1..n
] ++ ["\n"];