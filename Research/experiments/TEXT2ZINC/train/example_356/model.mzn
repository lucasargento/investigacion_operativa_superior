int: n = 5; % number of rows
int: len = (n*(n + 1)) div 2; % number of entries

% the triangle numbers for 1..n
array[1..n] of 1..len: t = [i*(i+1) div 2 | i in 1..n] ;

% the index of first number to use in the addition
array[1..t[n-1]] of var 1..len: adds;

% decision variables, the pyramid
array[1..len] of var int: x;

var int: X;
var int: Y;
var int: Z;


predicate contains(var int: e, array[int] of var int: a) =
   exists(i in 1..length(a)) (
      a[i] = e
   )
;

predicate cp1d(array[int] of var int: x, array[int] of var int: y) =
  assert(index_set(x) = index_set(y),
           "cp1d: x and y have different sizes",
     forall(i in index_set(x)) ( x[i] = y[i] ))
; 

solve satisfy;

constraint
   forall(i in 1..len) (x[i] >= 1)
   /\
   % 
   % the clues
   % 
   cp1d(x, [  151,
              _, _,
            40, _, _,
          _, _,_ , _ ,
         X, 11, Y, 4, Z
   ])

   /\
   % Calculate the sums of a triangle (general solution).
   
   %
   % 
   % create the indices of the numbers to add, i.e. adds[i] + adds[i+1]
   %
   adds[1] = 2
   /\
   forall(i in 2..t[n-1]) (
      % "jump" of 2 when i-1 is a triangle number
      ( contains(i-1,t) ->  adds[i] = adds[i-1] + 2 )
      /\
      ( not (contains(i-1, t)) ->  adds[i] = adds[i-1] + 1  )
   )

   /\ % position the number in their places
   forall(i in 1..t[n-1]) (
      x[i] = x[adds[i]]+x[adds[i]+1]
   )

   /\
   X >= 0 /\ Y >= 0 /\ Z >= 0
   /\
   X = x[11] /\ Y = x[13] /\ Z = x[15]
   /\
   Y = X + Z


%   % hard coded version
%    /\
%    x[2] + x[3] = x[1] /\
%
%    x[4] + x[5] = x[2] /\
%    x[5] + x[6] = x[3] /\
%
%    x[7] + x[8] = x[4] /\
%    x[8] + x[9] = x[5] /\
%    x[9] + x[10] = x[6] /\
%
%    x[11] + x[12] = x[7] /\
%    x[12] + x[13] = x[8] /\
%    x[13] + x[14] = x[9] /\
%    x[14] + x[15] = x[10]
;

output [
   "x: ", show(x), "\n",
   "[X,Y,Z]: ", show([X,Y,Z]),"\n",
   "t: ", show(t), "\n",
   "adds: ", show(adds), "\n",
]
;