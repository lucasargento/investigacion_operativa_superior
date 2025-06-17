int: n = 4;
int: m = 8;
array[0..n,1..m] of int: returns;

array[0..n, 1..m] of var 0..1: x; % x, MIP version
array[1..m] of var 0..n: choices; % the choices
array[1..m] of var int: the_returns;

int: budget = 10; % total 10 million
int: not_invested_returns = 5; % return for not invested (0.5*10)
var 0..budget: not_invested;
var 0..1000: z;


% solve satisfy;
% solve maximize z;
solve :: int_search(
        [x[i,j] | i in 0..n, j in 1..m],
        smallest, 
        indomain_min,
        complete) 
    maximize z;
    % satisfy;    

constraint
    forall(j in 1..m) (
       sum([x[i,j] | i in 0..n])  <= 1
    ) 
    /\
    % z >= 223 /\ % for solve satisfy
    z = sum(i in 0..n, j in 1..m, ) (
          returns[i,j]*x[i,j]
        ) + not_invested*not_invested_returns
    /\
    sum(i in 0..n, j in 1..m) (i*x[i,j])+not_invested <= budget

    /\
    forall(j in 1..m) (
       the_returns[j] >= 0 /\
       the_returns[j] = sum([returns[i,j]*x[i,j] | i in 0..n]) /\
       choices[j] = sum([i*x[i,j] | i in 0..n])
    )
;

% multiplied with 10
returns = array2d(0..n,1..m, [
 0, 0, 0, 0, 0, 0, 0, 0, % 0
41,18,15,22,13,42,22,10, % 1
58,30,25,38,24,59,35,17, % 2
65,39,33,48,32,66,42,23, % 3
68,45,38,55,39,68,46,28  % 4
]);


output
[
 "x: " ++ show(x) ++ "\n" ++
 "choices: " ++ show(choices) ++ "\n" ++
 "the_returns: " ++ show(the_returns) ++ "\n" ++
 "not_invested: " ++ show(not_invested) ++ "\n" ++
 "z: " ++ show(z) ++ "\n"

];