set of int: R = 1..10000;
%var R: X;
%var R: A;
%var R: B;
%var R: C;
%var R: D;

array[1..5] of var R: x;

solve satisfy;

constraint

  %X == A*3 + 1 /\
  %X == B*4 + 2 /\
  %X == C*5 + 3 /\
  %X == D*6 + 4

  % more general
  forall(i in 2..5) (
     x[1] = x[i]*(i+1) + i-1
  )

;

output [
"x: " ++ show(x) ++ "\n"

];