include "globals.mzn"; 

%
% Note: Normally the problem is stated as r = high+1 and c = r+1.
%       But there are some exceptions, e.g. domino_glaeser.dzn
%
int: r;               % rows
int: c;               % columns
int: m = (r*c) div 2; % number of pieces
int: high;            % highest number on a domino (i.e. [0,0] .. [high,high])

% data
array[1..m, 1..2] of 0..high: pieces; % the (id of the) pieces to use
array[1..r, 1..c] of 0..high: board;  % the data

% For Gecode's output representation (for the 0..6 variant)
array[1..m] of string: str = ["0","1","2","3","4","5","6","7","8","9",
                              "A","B","C","D","E","F","G","H","I","J",
                              "K","L","M","N","O","P","Q","R"];

% decision variables: which piece to place in each cell
array[1..r, 1..c] of var 1..m: x; % the solution

% solve satisfy;
solve :: int_search(
        [x[i,j] | i in 1..r, j in 1..c],
        largest, 
        indomain_max,
        complete) 
    satisfy;


constraint
  % we have exactly two occurrences of each piece
  % forall(p in 1..m) (
  %   count([x[i,j] | i in 1..r, j in 1..c], p, 2) :: domain
  % )
  % /\
  global_cardinality([x[i,j] | i in 1..r, j in 1..c], 
                     [i | i in 1..m], 
                     [2 | i in 1..m]) :: domain
;  

constraint
  % Get the two neighbours for the pieces.
  % This is a von Neumann grid, i.e. connect just
  % horizontally or vertically.
  forall(i in 1..r, j in 1..c) (
      exists(a,b in {-1,0,1} where
            i+a >= 1 /\ j+b >= 1 /\
            i+a <= r /\ j+b <= c
            % /\(abs(a) + abs(b) = 1)
            /\ 'xor'(abs(a)=1,abs(b)=1) 
           ) (

        (
          (pieces[x[i,j],1]     = board[i,j]     /\ pieces[x[i+a,j+b],2] = board[i+a,j+b])
          \/
          (pieces[x[i+a,j+b],1] = board[i+a,j+b] /\ pieces[x[i,j],2]     = board[i,j])
        )
        /\
        x[i,j] = x[i+a,j+b]
      ) 
  )
  /\ % adding this makes it quites faster:
  forall(p in 1..m) (
     exists(i in 1..r, j in 1..c, 
            a,b in {-1,0,1} where
                     i+a >= 1 /\ j+b >= 1 /\
                     i+a <= r /\ j+b <= c
                     % /\(abs(a) + abs(b) = 1)
                     /\ 'xor'(abs(a)=1,abs(b)=1) 
                      ) (
        (
          (pieces[p,1] = board[i,j] /\ pieces[p,2] = board[i+a,j+b])
          \/
          (pieces[p,1] = board[i+a,j+b] /\ pieces[p,2] = board[i,j])
        )
        /\
        x[i,j] = p
        /\
        x[i+a,j+b] = p
     ) 
  )
;


%
% the pieces (in lexicographic order)
%
pieces = array2d(1..m, 1..2, [ 
         if k = 1 then
           i
         else
           j
         endif
         | i in 0..high, j in  0..high, k in 1..2 
           where i <= j
         ]);


% Here are the representation of the dominos labelled 0..6 on a 7x8 grid,
% in lexicographic order.
%
% pieces = array2d(1..m, 1..2, [
%         % Two different representations: My and Gecode's
%         %  My  Gecode
%   0,0,  %  1   0
%   0,1,  %  2   1
%   0,2,  %  3   2
%   0,3,  %  4   3
%   0,4,  %  5   4
%   0,5,  %  6   5 
%   0,6,  %  7   6
%   1,1,  %  8   7
%   1,2,  %  9   8
%   1,3,  % 10   9
%   1,4,  % 11   A
%   1,5,  % 12   B
%   1,6,  % 13   C
%   2,2,  % 14   D
%   2,3,  % 15   E
%   2,4,  % 16   F
%   2,5,  % 17   G
%   2,6,  % 18   H
%   3,3,  % 19   I
%   3,4,  % 20   J
%   3,5,  % 21   K
%   3,6,  % 22   L
%   4,4,  % 23   M
%   4,5,  % 24   N
%   4,6,  % 25   O
%   5,5,  % 26   P
%   5,6,  % 27   Q
%   6,6,  % 28   R
% ]);


%
% Example from ECLiPSe domino.ecl
% (http://www.hakank.org/minizinc/domino_ecl.dzn)
%
% board = array2d(1..r, 1..c, 
%           [3,1,2,6,6,1,2,2,
%            3,4,1,5,3,0,3,6,
%            5,6,6,1,2,4,5,0,
%            5,6,4,1,3,3,0,0,
%            6,1,0,6,3,2,4,0,
%            4,1,5,2,4,3,5,5,
%            4,1,0,2,4,5,2,0]
%           );
%
% ECLiPSe's solution:
% """
%  3 - 1   2   6   6   1   2 - 2
%          |   |   |   |
%  3 - 4   1   5   3   0   3   6
%                          |   |
%  5   6 - 6   1   2 - 4   5   0
%  |           |
%  5   6   4   1   3   3 - 0   0
%      |   |       |           |
%  6   1   0   6   3   2   4   0
%  |           |       |   |
%  4   1 - 5   2   4   3   5   5
%                  |           |
%  4 - 1   0 - 2   4   5 - 2   0
% """

%
% This model presents the solution as
% """
%   Pieces:
%   10 10  9 27 22  2 14 14
%   20 20  9 27 22  2 21  7
%   26 28 28  8 16 16 21  7
%   26 13  5  8 19  4  4  1
%   25 13  5 18 19 15 24  1
%   25 12 12 18 23 15 24  6
%   11 11  3  3 23 17 17  6
%
%   Gecode's representation:
%   998QL1DD
%   JJ8QL1K6
%   PRR7FFK6
%   PC47I330
%   OC4HIEN0
%   OBBHMEN5
%   AA22MGG5
% """

%

output
[
 "Board:"
]
++
[
  if j = 1 then "\n" else " " endif ++
    show(board[i,j])
  | i in 1..r, j in 1..c
]
++
["\n\nPieces:"]
++
[
  if j = 1 then "\n" else " " endif ++
     if fix(x[i,j]) < 10 then " " else "" endif ++
     show(x[i,j])
  |i in 1..r, j in 1..c
]
++
[
  if m <= 28 then 
    "\n\nGecode's representation:"
  else 
    ""
  endif
]
++
[
  if m <= 28 then 
    if j = 1 then "\n" else "" endif ++
       str[fix(x[i,j])]
  else
    ""
  endif
  |i in 1..r, j in 1..c
]
% ++
% ["\n\nPositions of the pieces:\n"]
% ++
% [
%   % if fix(x[i,j]) = p then
%   %   show(x[i,j]) ++ ": " ++ show(i) ++ "," ++ show(j) ++ "\n"
%   % else "" endif
%   show(p) ++ ": " ++ show([if k = 1 then i else j endif | i in 1..r, j in 1..c, k in 1..2 where fix(x[i,j]) == p]) ++ "\n"
%   | p in 1..m% , i in 1..r, j in 1..c
% ]
++
["\n"];