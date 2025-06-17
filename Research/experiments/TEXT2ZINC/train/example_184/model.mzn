include "globals.mzn"; 

int: m = 4; % number of teams
int: n = 4; % size of team

int: p = m*n; % number of people: m*n

%
% (n*m)! /(((n!)^m)*m!)
% 
% m   n   #sol
% -----------
% 1  1  1
% 1  2  1
% 1  3  1
% 1  4  1
% 2  1  1
% 2  2  3
% 2  3  10
% 2  4  35
% 3  1  1
% 3  2  15
% 3  3  280
% 3  4  5775
% 4  1  1
% 4  2  105
% 4  3  15400
% 4  4  2627625


% decision variables
array[1..p] of var 1..m: x; % assign each person to a team number

% solve satisfy;
solve :: int_search(x, input_order, indomain_min, complete) satisfy;

function int: factorial(int: n) =  product([i | i in 1..n]);

constraint
   trace("m: " ++ show(m) ++ " n: " ++ show(n) ++ ": " ++ 
         show(factorial(n*m) div (( pow(factorial(n),m)*factorial(m)))) ++ "\n", true)
;

constraint
  % ensure that there are exactly n members in the team
  global_cardinality(x, [i | i in 1..m], [n | j in 1..m])

  /\ % symmetry breaking: 
     % the first occurrences of the team numbers (1..m) must be in order
  value_precede_chain([i | i in 1..m],x)
;

output [
  show(x)
];