int: n = 100;

% 0: nothing
% 1: fizz
% 2: buzz
% 3: fizzbuzz
array[1..n] of var 0..3: x; % 


%
% array <-> number
%
predicate toNum(array[int] of var int: number, var int: num_sum) =
          let { int: len = length(number) }
          in
          num_sum = sum(i in 1..len) (
            ceil(pow(10.0, int2float(len-i))) * number[i]
          )
          /\ forall(i in 1..len) (number[i] >= 0)
;


%
% does a contains e?
%
predicate contains(var int: e, array[int] of var int: a) =
   exists(i in 1..length(a)) (
      a[i] = e
   )
;

array[0..3] of string: fizz_buzz = array1d(0..3, ["", "fizz", "buzz", "fizzbuzz"]);

%solve satisfy;
solve :: int_search(x, first_fail, indomain_min, complete) satisfy;


constraint
   forall(i in 1..n) (
     let {
        array[1..3] of var 0..9: a
     }
     in
     toNum(a, i)
     /\
     (
      ( 
        (i mod 3 = 0 /\ i mod 5 = 0) 
         \/ 
        (contains(3, a) /\ contains(5, a))
         \/
        (i mod 3 = 0 /\ contains(5, a)) 
         \/
        (i mod 5 = 0 /\ contains(3, a)) 

       )
        <-> x[i] = 3  % fizz buzz
     )
     /\
     (
      (
       (i mod 3 = 0 \/ contains(3, a) )
       /\
       (i mod 5 > 0 /\ not(contains(5, a) ))
      )
      <-> x[i] = 1  % fizz
     )
     /\
     (
      (
       (i mod 5 = 0 \/ contains(5, a)) 
       /\
       (i mod 3 > 0 /\ not(contains(3, a) ))
      )
      <-> x[i] = 2 % buzz
     )
     /\
     (
       (
        i mod 3 > 0 /\ i mod 5 > 0 /\ 
        not(contains(3,a)) /\ not(contains(5,a))
       )
        <-> x[i] = 0
      )


   )
;

output 
% [
%   show(i) ++ ": " ++ show(x[i]) ++ "\n"
%   | i in 1..n
% ] ++ 
[
  let {
    int: t = fix(x[i])
  } in
    show(i) ++ ": " ++
    if t = 0 then show(i) else show(fizz_buzz[t]) endif ++
    "\n"
  | i in 1..n
] ++
["\n"];