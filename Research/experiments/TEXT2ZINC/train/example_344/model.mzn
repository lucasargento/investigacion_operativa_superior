include "globals.mzn"; 

int: n;
array[1..n, 1..n] of var 1..n: x;
array[1..n, 1..n] of 1..n: streams;
int: num_placed;
array[1..num_placed, 1..3] of 1..n: placed;


solve satisfy;

constraint

   % latin square
   forall(i in 1..n) (
       all_different([ x[i, j] | j in 1..n]) /\
       all_different([ x[j, i] | j in 1..n])
   )
   /\ 
   % streams
   forall(s in 1..n) (
       all_different([x[i,j] | i,j in 1..n where streams[i,j] = s])
   )

   /\ 
   % placed
   forall(i in 1..num_placed) (
       x[placed[i,1], placed[i,2]] = placed[i,3]
   )

;


%
% data
%
% Strimko Set 068
% n = 4;

% % represent the different streams with integer 1..n
% streams = array2d(1..n, 1..n, [
%                     1,2,2,4,
%                     2,1,4,2,
%                     3,4,1,3,
%                     4,3,3,1
%                   ]);

% num_placed = 3;
% placed = array2d(1..num_placed, 1..3, [
%                               2,2,3,
%                               2,3,2,
%                               3,3,1
%                             ]);



output
[ if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  |  i,j in 1..n
];