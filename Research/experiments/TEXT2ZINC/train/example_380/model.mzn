float: v = pow(10.0,8.0);

array[1..2] of var -v..v: x;


% solve satisfy;
solve :: float_search(x, 0.00000000000001, input_order, indomain_split, complete) satisfy;

constraint
   x[1]*x[1] + x[2]*x[2] = 1.0 
   /\
   x[1]*x[1] = x[2]
   
   % additional constraint
   % /\ x[1] >= 0.0
;

output [
  "x:" ++ show(x) ++ "\n"
];