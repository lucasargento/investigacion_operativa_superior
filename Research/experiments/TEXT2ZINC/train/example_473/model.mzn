int: n = 7;
array[1..n] of var 0..4: variables;
var 0..10: low;
var 0..10: up;
1..n: seq = 4;

predicate sliding_sum(var int: low, var int: up, int: seq, array[int] of var int: variables) =
  forall(i in min(index_set(variables))..max(index_set(variables))-seq+1) (
    let {
      var int: s
    }
    in
    s = sum(j in i..i+seq-1) (
      variables[j]
    )
    /\
    s >= low
    /\
    s <= up
  )
;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 


solve satisfy;

constraint
  % cp1d(variables, [1,4,2,0,0,3,3])
  % /\
  low = 3
  /\
  up = 7
  /\
  sliding_sum(low, up, seq, variables)
;

output [
"low: " ++ show(low) ++ "\n"++
"up: " ++ show(up) ++ "\n"++
"seq: " ++ show(seq) ++ "\n"++
"variables: " ++ show(variables) ++ "\n"
];