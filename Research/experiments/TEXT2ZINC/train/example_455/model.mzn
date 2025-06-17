int: n = 3;
int: max_time = 13;
array[1..n, 1..2] of var 1..max_time: tasks;
int: window_size = 9;
var int: limitx;
int: start = 5;
array[start..start+window_size-1] of var 0..n: occupied;

predicate sliding_time_window_from_start(
                                   int: window_size, 
                                   var int: limitx, 
                                   array[int, 1..2] of var int: tasks, 
                                   int: start) =

   % how many tasks occupies this time entry
   forall(i in start..start+window_size-1) (
      occupied[i] = sum(j in min(index_set_1of2(tasks))..max(index_set_1of2(tasks))) (
         bool2int(
             i >= tasks[j, 1] /\ i < tasks[j, 1] + tasks[j, 2]
         )
      )
   )
  /\
  limitx >=  sum(occupied)
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

solve satisfy;

constraint
  limitx = 6
  /\
  cp2d(tasks, array2d(1..n, 1..2, 
     [
       10,3,
        5,1,
        6,2
     ]))
   /\
   sliding_time_window_from_start(window_size, limitx, tasks, start)
;


output [
"window_size: " ++ show(window_size) ++ "\n"++
"limitx: " ++ show(limitx) ++ "\n"++
"tasks: " ++ show(tasks) ++ "\n"++
"start: " ++ show(start) ++ "\n" ++
"occupied: " ++ show(occupied) ++ "\n"
];