int: n = 4;
int: m = 2;
array[1..n, 1..m] of var 0..1: arr;
array[1..m] of var 0..1: v1;
array[1..m] of var 0..1: v2;

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

%
% Generalized version of cond_lex_*
%
predicate cond_lex_op(array[int] of var int: vec1, array[int] of var int: vec2, array[int, int] of var int: a, int: xop) =
     let {
       int: lba = min(index_set_1of2(a)),
       int: uba = max(index_set_1of2(a)),
       var lba..uba: p1,
       var lba..uba: p2
     }
     in
       forall(j in index_set(vec1)) (
         a[p1,j] = vec1[j]
       ) 
       /\
       forall(j in index_set(vec2)) (
         a[p2,j] = vec2[j]
       ) 
       /\
       cmp(p1, p2, xop)
;


%
% cond_lex_less
%
predicate cond_lex_less(array[int] of var int: vec1, array[int] of var int: vec2, array[int, int] of var int: a) =
    cond_lex_op(vec1, vec2, a, -2)
;

%
% cond_lex_lesseq
%
predicate cond_lex_lesseq(array[int] of var int: vec1, array[int] of var int: vec2, array[int, int] of var int: a) =
    cond_lex_op(vec1, vec2, a, -1)
;

%
% cond_lex_greater
%
predicate cond_lex_greater(array[int] of var int: vec1, array[int] of var int: vec2, array[int, int] of var int: a) =
    cond_lex_op(vec1, vec2, a, 2)
;

%
% cond_lex_greatereq
%
predicate cond_lex_greatereq(array[int] of var int: vec1, array[int] of var int: vec2, array[int, int] of var int: a) =
    cond_lex_op(vec1, vec2, a, 1)
;

predicate cp1d(array[int] of int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) ( x[i] = y[i] ) )
; 

predicate cp2d(array[int,int] of int: x, array[int,int] of var int: y) =
  assert(index_set_1of2(x) = index_set_1of2(y) /\
         index_set_2of2(x) = index_set_2of2(y),
           "cp2d: x and y have different sizes",
      forall(i in index_set_1of2(x), j in index_set_2of2(x)) (
         y[i,j] = x[i,j]
     ) 
  )
; 

solve satisfy;

constraint
    cp2d([|1,0,
           |0,1,
           |0,0
           |1,1|], arr)
    /\
    cp1d([1,0], v1)
    /\
    cp1d([0,0], v2)
    /\
    cond_lex_less(v1, v2, arr)
    %cond_lex_lesseq(v1, v2, arr)

    % v1 = [0,1]
    % /\
    % v2 = [1,0]
    % /\
    % cond_lex_greater(v1, v2, arr)
    % cond_lex_greatereq(v1, v2, arr)
    
;

output
[
  "arr: " ++ show(arr) ++ "\n" ++
  "v1: " ++ show(v1) ++ "\n" ++
  "v2: " ++ show(v2) ++ "\n" 
];