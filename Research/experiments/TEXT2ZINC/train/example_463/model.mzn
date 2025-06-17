include "globals.mzn"; 

int: n = 3;
array[1..n] of var 1..10: x;
array[1..n, 1..2] of var 0..10*2: intervals;
var 1..9: size_interval;


%
% alldifferent_interval(VARIABLES, SIZE_INTERVAL, INTERVALS)
%
predicate alldifferent_interval(array[int] of var int: variables, 
                                var int: size_interval, 
                                array[int, int] of var int: intervals) =
  let {
     int: lbx = min(index_set(variables)),
     int: ubx = max(index_set(variables))
  } 
  in
  all_different(variables)

  /\ % interval[i] > interval[i-1]
   forall(i in lbx+1..ubx) (  
     intervals[i,1] > intervals[i-1,2]
  )
  /\ % assure the size of interval 
     % and check that x[i] is in the i'th interval
  forall(i in lbx..ubx) (  
    intervals[i, 2] - intervals[i, 1] = size_interval - 1
    /\
    variables[i] >= intervals[i, 1]
    /\
    variables[i] <= intervals[i, 2]      
  )
  /\ % get the k
  exists(k in lbx..ubx) (
    intervals[k, 1] = size_interval*k
    /\
    intervals[k, 2] = size_interval*k+size_interval-1
  )
;

predicate cp1d(array[int] of int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
    forall(i in index_set(x)) (
       x[i] = y[i]
    )
  )
; 


solve satisfy;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
  cp1d([2, 3, 10],x)
  /\
  alldifferent_interval(x, size_interval, intervals)
  %/\ 
  %size_interval = 3
;


output [
  "x: " ++ show(x) ++ "\n" ++
  "size_interval: " ++ show(size_interval) ++ "\n" ++
  "intervals: " ++ show(intervals) ++ "\n"
];