int: T = 3; % time period

% comment one of the initiations to calculate it:
var 0.0..10000.0: I = 10.0/100.0;
var 0.0..10000.0: R = 150.0; 
var 0.0..10000.0: P; % = 373.02779864763318;

array[1..T] of var float: mortgage;

% solve satisfy;
% solve :: float_search(mortgage, 0.00000001, input_order, indomain_split, complete) satisfy;
solve minimize P;

constraint
   forall(i in 1..T) ( mortgage[i] >= 0.0) /\

   % start value:
   mortgage[1] = P + (P  * I) - R /\
   forall(i in 2..T) (
     % calculate the next value using a local variable
     % This is the recursion in the CLP example.
     % let {
     %    var float: NP = mortgage[i-1] + (mortgage[i-1]  * I) - R 
     % }
     % in
     % in
     % mortgage[i] =  NP /\ NP >= 0.0
     % [Later note: This is simpler. :-)]
     mortgage[i] = mortgage[i-1] + (mortgage[i-1]  * I) - R
   )
;

output [
   "P: ", show(P), "\n",
   "I: ", show(I), "\n",
   "R: ", show(R), "\n",
   "mortgage: ", show(mortgage),"\n", % is not especially interesting
];