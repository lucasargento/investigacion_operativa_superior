include "globals.mzn"; 

int: n = 5;
array[1..n] of var 1..7: x;
var 0..n: bal;
int: m = 3;

predicate min_except_0(var int: min_val, array[int] of var int: x) =

     exists(i in index_set(x)) (
       min_val = x[i] /\ 
       forall(j in index_set(x) where i != j) (
         x[i] <= x[j]
         \/ % ignore 0
         x[j] = 0
       )
     )
     /\
     min_val > 0
;


predicate balance_modulo(var int: bal, array[int] of var int: x, int: m) =
   let {
     int: lbx = min(index_set(x)),
     int: ubx = max(index_set(x)),
     array[0..m-1] of var 0..ubx: counts,
     var 0..ubx: c_max,
     var 0..ubx: c_min
   }
   in
   forall(i in 0..m-1) (
      counts[i] = sum(j in index_set(x)) ( bool2int( (x[j] mod m) = i))
   )
   /\ 
   c_max = max(counts)
   /\
   min_except_0(c_min, counts)
   /\
   bal = c_max - c_min
;

predicate cp1d(array[int] of int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
  forall(i in index_set(x)) (
      x[i] = y[i]
  )
  )
; 


% solve :: int_search(x ++ [bal], first_fail, indomain_min, complete) satisfy;
solve satisfy;

constraint
  cp1d([6,1,7,1,5], x)
  /\
  balance_modulo(bal, x, m)
  %/\
  %bal = 2

;


output [
  "x: ", show(x), "\n",
  "bal: ", show(bal), "\n"
];