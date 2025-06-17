int: n = 4;
array[1..n, 1..n] of var 0..1: x;

%
%
predicate antisymmetric1(array[int, int] of var 0..1: x) =
   let {
       int: n = card(index_set_1of2(x))
   }
   in
   %  not(iRi)
   forall(i in 1..n) (
      x[i,i] = 0
   )
   /\ % if iRj then not(jRi)
   forall(i, j in 1..n where i != j) (
      x[i,j] = 1 <-> x[j,i] = 0
   )
;

%
% Alternative version from the definition in
% http://en.wikipedia.org/wiki/Antisymmetric_relation
%  * if aRb with a != b, then not bRa
%
predicate antisymmetric2(array[int, int] of var 0..1: x) =
   let {
       int: n = card(index_set_1of2(x))
   }
   in
   forall(a, b in 1..n) (
      (x[a,b] = 1 /\ a != b) <-> x[b,a] = 0
   )
;


solve satisfy;
% solve :: int_search(x, "first_fail", "indomain", "complete") satisfy;

constraint
   antisymmetric1(x)
   % antisymmetric2(x)
;

output[
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i, j in 1..n
] 
++ 
["\n"]
;