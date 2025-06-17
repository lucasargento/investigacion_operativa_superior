int: n = 11; % number of Fibonacci numbers to calculate
array[1..n] of var int: fib;

solve satisfy;

constraint
        fib[1] = 1 /\
        fib[2] = 1 /\
        forall(i in 3..n) (
             fib[i] = fib[i-1] + fib[i-2]
        )        
;


output [
  show(fib), "\n"
];