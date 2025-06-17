float: pi = 3.141592653589793;

function var float: area(var float: r) = pi*r*r;
function var float: circumference(var float: r) = 2*pi*r;

% decision variables
var 0.0..10000.0: r1;
var 0.0..10000.0: r2;

solve satisfy;

constraint
  r1 <= r2 /\

  circumference(r1) + circumference(r2) = 10322*pi /\
  area(r1) +area(r2) = 13946281*pi
;

% output [

% ];