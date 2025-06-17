int: n = 3; % number of men

array[0..n] of var int: left;
array[1..n+1] of var int: removed;



solve satisfy;
% solve :: int_search(left ++ removed, "first_fail", "indomain", "complete") satisfy;
% solve :: int_search(left ++ removed, first_fail, indomain_median, complete) minimize left[0];
% solve minimize left[0];

constraint 
  forall(i in 0..n)   ( left[i] >= 0 ) 
  /\
  forall(i in 1..n+1) ( removed[i] >= 0 ) 
  /\
  forall(i in 0..n-1) ( 
     left[i] = n*removed[i+1] + 1 
     /\ 
     left[i+1] = (n-1)*removed[i+1]
  ) 
  /\
  left[n] = n*removed[n+1] + 1
;


output [
  "original #: " ++ show(left[0]) ++ "\n" ++
  "left: " ++ show(left) ++ "\n" ++
  "removed: " ++ show(removed) ++ "\n"

];