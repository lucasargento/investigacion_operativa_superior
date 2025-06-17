array[1..3] of 1..100: v = [15,16,17];
array[1..3] of var int: x;

int: requ = 121; % i.e. 11 * 11

constraint
        forall(i in 1..3) (x[i] >= 0) 
        /\
        sum(i in 1..3) (v[i]*x[i]) = requ
;

solve minimize sum(i in 1..3) (x[i]);

output
[
  "x: " ++ show(x)
];