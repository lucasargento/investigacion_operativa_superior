int: N = 300;
float: Nf = int2float(N);

var -Nf..Nf: C; % Celsius
var -Nf..Nf: F; % Fahrenheigh

var -N..N: Ci;
var -N..N: Fi;

predicate convert(var float: C, var float: F) =
  C = (F - 32.0) * 5.0 / 9.0
;

% solve satisfy;
solve :: float_search([C,F],0.01,input_order,indomain_split, complete) satisfy;

constraint

%  F = 100.0
%  /\
%  C = 37.0
%  /\
  convert(C, F)
%  /\
%  C = F

  % /\ (C >= 1.0 \/ F >= 1.0)

  % /\ % either C or F must be an integer
  % floor(F) = F  % floor don't accept var float
 
  % both C and F must be integers
  /\ int2float(Ci) = C 
  /\ int2float(Fi) = F

  % This works
  % /\ exists(i in -N..N) ( int2float(i) = C )
  % /\ exists(i in -N..N) (  int2float(i) = F )

;


output [
  "C: ", show(C), "\n",
  "F: ", show(F), "\n",

];