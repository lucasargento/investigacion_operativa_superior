int: Tweety = 1;
int: Toto = 2;

set of int: Bird = Tweety..Toto;
% var Bird: x;
array[1..2] of Bird: birds = [Tweety, Toto];

array[Bird] of var 0..1: flies; % which flies?

predicate penguin(var Bird: x) =
  x = Tweety
;

predicate eagle(var Bird: x) = 
  x = Toto
;

predicate ab(var Bird: x) = 
  penguin(x)	
;

predicate bird(var Bird: x) = 
  penguin(x) 
  \/ 
  eagle(x)
;


predicate fly(var Bird: x) = 
  bird(x) 
  /\ 
  not(ab(x))
;

predicate does_fly(var Bird: x, var 0..1: f) = 
  f = 1 <-> (bird(x) /\ not(ab(x)))
;


solve satisfy;

constraint
   % fly(x)
   forall(t in Bird) (
     does_fly(t, flies[t])
   )
;

output
[
  show(flies)
];