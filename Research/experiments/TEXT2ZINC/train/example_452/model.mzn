int: n = 4;
array[1..n, 1..2] of var 1..9: x;
var set of 1..9: s;
var int: total;

solve satisfy;

predicate sum_set(array[int, 1..2] of var int: a, var set of int: ss, var int: tot, int: xop, var int: cmp_val) =
  let {
    array[1..card(index_set_1of2(a))] of var 0..ub_array(a): tmp
  }
  in
  forall(i in index_set_1of2(a)) (
    (a[i,1] in ss <-> tmp[i] = a[i,2])
    /\
    (not(a[i,1] in ss) -> tmp[i] = 0)
  )
  /\
  tot = sum(tmp)
  /\
  cmp(tot, cmp_val, xop)
;


%
% Since MiniZinc don't handle function variables we use the following
% hack where t is the type of comparison operator.
% t:
%  - 2 :  a <  b
%  - 1 :  a <= b
%    0 :  a  = b
%    1 :  a >= b
%    2 :  a >  b
% else : a != b
%
predicate cmp(var int: a, var int: b, int: t) =
   if     t = -2 then
     a < b
   elseif t = -1 then
     a <= b
   elseif t =  0 then
     a = b
   elseif t =  1 then
     a >= b
   elseif t =  2 then
     a > b
   else
     a != b
   endif
;

predicate cp2d(array[int,int] of var int: x, array[int,int] of var int: y) =
  assert(index_set_1of2(x) = index_set_1of2(y) /\
         index_set_2of2(x) = index_set_2of2(y),
           "cp2d: x and y have different sizes",
     forall(i in index_set_1of2(x), j in index_set_2of2(x)) (
         y[i,j] = x[i,j]
    ) 
  )
; 

constraint

  cp2d(x, array2d(1..n, 1..2, 
  [2, 7,
   9, 1,
   5, 7,
   6, 2
  ]))
  /\
  s = {2,3,6}
  /\
  sum_set(x, s, total, 0, total)
  /\
  total = 9
;

output [
"x: " ++ show(x) ++ "\n"++
"s: " ++ show(s) ++ "\n"++
"total: " ++ show(total) ++ "\n"
];