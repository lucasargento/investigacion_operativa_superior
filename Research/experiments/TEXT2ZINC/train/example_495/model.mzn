int: bits = 16;

array[1..bits] of var 0..1: num_x;
var int: num;

array[1..bits] of var 0..1: num2_x;
var int: num2;

array[1..bits] of var 0..1: num3_x;
var int: num3;


predicate toNum(array[int] of var int: a, var int: n,  float: base) =
          let { int: len = length(a) }
          in
          n = sum(i in 1..len) (
            ceil(pow(base, int2float(len-i))) * a[i]
          )
          /\ forall(i in 1..len) (a[i] >= 0)
;


% solve satisfy;
solve :: int_search(num_x ++ num2_x ++ num3_x, smallest, indomain_min, complete) satisfy;

constraint
   toNum(num_x, num, 2.0) 
   /\
   num2 = num*2
   /\
   toNum(num2_x, num2, 2.0)
   /\
   toNum(num3_x, num3, 2.0)
   /\
   forall(i in bits-3..bits) (
      num3_x[i] = 1 <-> num2_x[i] = 0
   )
   /\
   num = num3
;

output [
  "num : " ++ show(num)  ++ " num_x : " ++ show(num_x)  ++ "\n" ++
  "num2: " ++ show(num2) ++ " num2_x: " ++ show(num2_x) ++ "\n" ++
  "num3: " ++ show(num3) ++ " num3_x: " ++ show(num3_x) ++ "\n"
]
 ++ ["\n"]
;