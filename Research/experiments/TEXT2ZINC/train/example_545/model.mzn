int: n = 4;
int: m = 8;
array[0..n,1..m] of int: returns;

array[1..m] of var 0..n: x;
array[1..m] of var int: the_returns;

int: budget = 10; % total 10 million
int: not_invested_returns = 5; % return for not invested (0.5*10)
var 0..budget: not_invested;
var 0..1000: z;


% solve satisfy;
% solve maximize z;
solve :: int_search(
        x, 
        input_order, 
        indomain_min,
        complete) 
    % maximize z;
    satisfy;    

constraint
    z >= 223 /\ % for solve satisfy
    z = sum(i in 1..m) (
          returns[x[i],i]
      ) + not_invested*not_invested_returns
    /\
    sum(x)+not_invested <= budget
    /\
    forall(i in 1..m) (
       the_returns[i] >= 0 /\
       the_returns[i] = returns[x[i],i]
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
  "x:" ++ show(x)  ++ "\n" ++
  "the_returns:" ++ show(the_returns)  ++ "\n" ++
  "not_invested:" ++ show(not_invested)  ++ "\n" ++
  "z:" ++ show(z)  ++ "\n"

];