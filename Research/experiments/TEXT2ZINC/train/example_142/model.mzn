include "globals.mzn"; 
int: n = 9;
array[1..n, 1..n] of var 1..9: x;

% For a better view of the problem, see
%  http://en.wikipedia.org/wiki/File:Killersudoku_color.svg
%

%
% segments
%
int: num_segments = 29; % number of segments

array[1..n, 1..n] of int: segments =
array2d(1..n, 1..n,
[
  1, 1, 2, 2, 2, 3, 4, 5, 6, % 1
  7, 7, 8, 8, 3, 3, 4, 5, 6, % 2
  7, 7, 9, 9, 3,10,11,11, 6, % 3
 13,14,14, 9,15,10,11,12, 6, % 4
 13,16,16,17,15,10,12,12,18, % 5
 19,16,20,17,15,21,22,22,18, % 6
 19,20,20,17,23,21,21,24,24, % 7
 19,25,26,23,23,27,27,24,24, % 8
 19,25,26,23,28,28,28,29,29, % 9
]);

array[1..num_segments] of int: segment_sums =
[
   3, % 1
  15, % 2
  22, % 3
   4, % 4
  16, % 5
  15, % 6
  25, % 7
  17, % 8
   9, % 9
   8, % 10
  20, % 11
  17, % 12
   6, % 13
  14, % 14
  17, % 15
  13, % 16
  20, % 17
  12, % 18
  27, % 19
   6, % 20
  20, % 21
   6, % 22
  10, % 23
  14, % 24
   8, % 25
  16, % 26
  15, % 27
  13, % 28
  17  % 29
];

% solve satisfy;
solve :: int_search([x[i,j] | i,j in 1..n], first_fail, indomain_min, complete) satisfy;

% Standard Sudoku constraints
constraint
  % rows and columns
  forall(i in 1..n) (
     all_different([x[i,j] | j in 1..n]) /\
     all_different([x[j,i] | j in 1..n])
  )
  /\ % blocks
  forall(i in 0..2,j in 0..2) (
    all_different([x[r,c] | r in i*3+1..i*3+3, c in j*3+1..j*3+3] )
  )
;

% Handle the segments
constraint
  forall(p in 1..num_segments) (
    segment_sums[p] = sum([x[i,j] | i,j in 1..n where segments[i,j] = p])
  )
;

output [
  if j = 1 then "\n" else " " endif ++
    show(x[i,j])
  | i,j in 1..n
];