int: n = 2;

% decision variables
int: ll = 10;
int: uu = 50;

array[ll..uu] of var 0..1: x;
% var set of ll..uu: x; % set based

solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
   forall(i in ll..uu) (
       i mod (i mod 10) = 0 <-> x[i] = 1 % array based
       % i mod (i mod 10) = 0 <-> i in x     % set based
   )
;

output 
[
  "sum: " ++ show(sum(x)) ++ "\n" % array based
  % "sum: " ++ show(card(x)) ++ "\n"  % set based
  ++ 
  show(x) ++ "\n"
]
++
[ % array based
  if fix(x[i]) == 1 then show(i) ++ " " else "" endif
  | i in ll..uu
]
;