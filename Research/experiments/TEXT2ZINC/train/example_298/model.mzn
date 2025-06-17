array[1..2] of var int: x;

solve satisfy;

constraint 
  25*x[1] + 49*x[2] = 2000
  /\
  forall(i in 1..2) (
    x[i] >= 0
  )
;


output [show(x)];