include "globals.mzn";

var 1000..9999: x;

constraint (x*x mod 10000) = x;

solve satisfy;

output ["The four-digit integer is: ", show(x)];