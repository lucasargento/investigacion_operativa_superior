set of int: S = 1..3;
% array[S] of 0.0..3.0: amount = [3.0, 2.0, 0.5]; % float version
array[S] of 0..6: amount = [6, 4, 1]; % multiply with 2 for the integer solution
array[S] of var 0..1000: x;

solve satisfy;

constraint
   % float version
   % sum(i in S) (amount[i]*int2float(x[i])) = 100.0
   % /\
   % sum(i in S) (x[i]) = 100
   % /\
   % x[2] = 5*x[1]

   % integer version
   sum(i in S) (amount[i]*x[i]) = 200
   /\
   sum(i in S) (x[i]) = 100
   /\
   x[2] = 5*x[1]
;

output [
  show(x), "\n",
];