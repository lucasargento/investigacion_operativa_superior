int: n = 10;
var int: z;


predicate factorial(int: n, var int: res) =
   let {
      array[1..n] of var int: x
   }
   in
   x[1] = 1
   /\
   forall(i in 2..n) (
     x[i] = x[i-1]*i 
   )
   /\
   res = x[n] 

; 

solve satisfy;

constraint
   factorial(n, z)

;

output [
  "n: ", show(n),"\n",
  "z: ", show(z), "\n",
];