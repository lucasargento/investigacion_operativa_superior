int: n =  20;
array[0..n-1] of var 0..n-1: s;

solve satisfy;

constraint
  forall(i in 0..n-1) (
    s[i] = sum(j in 0..n-1) (bool2int(s[j] = i))
  )
;


output [
       show(s), "\n"
];