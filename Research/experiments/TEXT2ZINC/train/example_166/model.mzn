include "globals.mzn"; 
int: n = 8;
int: p = ceil(pow(2.0,int2float(n)));

% array[0..p-1, 1..n] of var 0..1: x;
array[0..p-1] of var set of 1..n: s;

% array <-> integer given a base
predicate toNum(array[int] of var int: a, var int: n,  float: base) =
    let { int: len = length(a) }
    in
    n = sum(i in 1..len) (
      ceil(pow(base, int2float(len-i))) * a[i]
    )
    /\ forall(i in 1..len) (a[i] >= 0)
;

predicate powerset(int: n, array[int] of var set of int: s) =
  let {
    int: p = ceil(pow(2.0,int2float(n))),
    array[0..p-1, 1..n] of var 0..1: x%
  } in
    forall(i in 0..p-1) (
       % convert integer 0..p-1 to binary representation
       toNum([x[i,j] | j in 1..n], i, 2.0) /\
       % convert this binary representation to set
       forall(j in 1..n) (
           x[i,j] = 1 <-> (n-j+1) in s[i]
       )
    )
;


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
    powerset(n, s)
;

output
[
  show(s)
];