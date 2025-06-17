var 0.0..pow(10.0,8.0): x;


solve satisfy;
% solve :: float_search([x], 0.00001, input_order, indomain_split, complete) satisfy;

constraint
  x*x*x*x - 12.0*x*x*x + 47.0*x*x - 60.0*x + 24.0 = 0.0
  % x*x*x*x - 12.0*x*x*x + 47.0*x*x - 60.0*x + 24.1 = 0.0 % variant: this should fail
;

output [
  "x:" ++ show_float(3,12,x)
];