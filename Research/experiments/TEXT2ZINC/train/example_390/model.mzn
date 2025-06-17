var {50, 100, 200}: W; 
var 2..5: L; 

var float: V; % the volume to minimize
float: pi = 3.1415926535897931; 

% solve minimize V;
solve :: float_search([V], 0.01, input_order, indomain_split, complete) minimize V;

constraint 
  V >= 2.0 /\
  V = 1.0*(int2float(W)/100.0) * (int2float(L*L)/(4.0*pi))
;

output 
[
  "W: ", show(W), "\n",
  "L: ", show(L), "\n",
  "V: ", show(V), "\n",
];