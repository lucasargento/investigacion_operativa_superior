float: v = pow(10.0,8.0);

var -v..v: x;
var -v..v: y;


% solve satisfy;
solve :: float_search([x,y], 0.00000000000001, input_order, indomain_split, complete) satisfy;

constraint
   x*x + y*y = 1.0 
   /\
   x*x = y
   
;

output [
  "x:" ++ show_float(3,12,x) ++ "\n" ++
  "y:" ++ show_float(3,12,y)
];