var -100.00..10.00: x; 

solve minimize x;
% solve::float_search([x], 0.000001, input_order, indomain_split, complete) minimize x;

output [
 show(x)
];

constraint
%   x >= -100.0 /\ x <= 10.0
%   /\
  0.0 = (x+1.0)*(x+2.0)*(x+3.0)*(x+4.0)*(x+5.0)*(x+6.0)*(x+7.0)*(x+8.0)*(x+9.0)*(x+10.0)*(x+11.0)*(x+12.0)*(x+13.0)*(x+14.0)*(x+15.0)*(x+16.0)*(x+17.0)*(x+18.0)*(x+19.0)*(x+20.0)
      + 0.00000011920928955078*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x
                              % this is x**19
;