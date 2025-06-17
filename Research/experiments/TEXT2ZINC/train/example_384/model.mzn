var -20.0..20.00: x;
var -20.0..20.00: y;
var -20.0..20.00: z;

% var float: x;
% var float: y;
% var float: z;


% solve satisfy;
solve :: float_search([x,y,z], 0.0001, input_order, indomain_split, complete)  satisfy;

constraint
        13.0 + y*y*(1.0+z*z) + z*(z - 24.0*y)  = 0.0 /\
        13.0 + z*z*(1.0+x*x) + x*(x - 24.0*z)  = 0.0 /\
        13.0 + x*x*(1.0+y*y) + y*(y - 24.0*x)  = 0.0 
 ;


output [
"x: " ++ show(x) ++ "\n"++
"y: " ++ show(y) ++ "\n"++
"z: " ++ show(z) ++ "\n"
];