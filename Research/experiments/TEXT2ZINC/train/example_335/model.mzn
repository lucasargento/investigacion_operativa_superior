int: n = 5;
int: m = 112;
int: x = 65536;
var int: d_x;
array[1..m] of var int: d_roots;

%
% digital root 
%
predicate digital_root(var int: num, var int: res, var int: base) =
   res = 1 + ((num-1) mod (base-1))
;


% % solve satisfy;
% solve :: int_search(d_roots, first_fail, indomain_min, complete) satisfy;

constraint
   forall(i in 1..m) (
      digital_root(i, d_roots[i],10)
   )
   /\
   digital_root(x, d_x, 10)
;

output 
[ 
  "x: ", show(x), "\n",
  "d_x: ", show(d_x), "\n",
] ++
[
  % "digital_roots: ", show(d_roots), "\n"
  show(i) ++ ":" ++ show(d_roots[i]) ++ "\n"
  | i in 1..m
] ++ ["\n"];

% output in valid json format
output [
  "{\n",
  "  \"x\": ", show(x), ",\n",
  "  \"d_x\": ", show(d_x), ",\n",
  "  \"digital_roots\":\n  {\n",
] ++ 
[
   % "digital_roots: ", show(d_roots), "\n"
   "    \"" ++ show(i) ++ "\""++ ": " ++ show(d_roots[i]) ++ ",\n"
   | i in 1..m-1
] ++
[
   "    \"" ++ show(m) ++ "\""++ ": " ++ show(d_roots[m]) ++ "\n"
] ++ 
[
  "  }\n",
  "}\n"
];