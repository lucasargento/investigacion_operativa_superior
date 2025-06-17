include "globals.mzn"; 

int: n = 5;
array[1..n] of var 1..20: origin;
array[1..n] of var 1..20: duration;
array[1..n] of var 1..20: height;
array[1..n] of var 1..20: end;
var 0..10: limitx; % = 7;  % note: the minimum limit is 7

% solve satisfy;
% solve minimize limitx;
solve minimize max(end);

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) ( x[i] = y[i] ) )
; 


constraint
  % origin = [1,2,3,6,7]
  duration = [3,9,10, 6,2] /\
  % end = [4,11,13,12,9]
  height = [1,2,1,1,3] /\

  % Note: If we use cumulative from globals.mzn we must handle 
  % end = origin + duration by ourselves
  cumulative(origin, duration, height,limitx)
  /\
  forall(i in 1..n) (
    end[i] = origin[i] + duration[i]
  )
;

output [
  "limit   : ", show(limitx), "\n",
  "origin  : ", show(origin), "\n",
  "duration: ", show(duration), "\n",
  "height  : ", show(height), "\n",
  "end     : ", show(end), "\n",

];