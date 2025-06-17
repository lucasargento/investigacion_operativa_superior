include "globals.mzn"; 

% the dimension of the matrix (row x cols)
int: rows = 1;
int: cols = 64;

% the base to use, i.e. the alphabet 0..base-1
int: base = 2;

% dimensions of the sub squares (m1 x m2)
int: m1 = 1; % rows
int: m2 = 6; % cols

% decision variables 
% 
% extra: number of added row(s)/column(s)
int: extra1 = m1-1;
int: extra2 = m2-1;
% the matrix
array[0..rows-1+extra1, 0..cols-1+extra2] of var 0..base-1: x;

% convert the sub matrix to numbers
% int: sub_max = ceil(pow(int2float(base), int2float(m1*m2)))-1;
% array[0..rows*cols-1] of var 0..sub_max: y;

% count of the occurrences of numbers in y
% array[0..base-1] of var 0..rows*cols: gcc;

% var 0..sub_max: max_val;


% convert the array a to number n in base base
predicate toNum(array[int] of var int: a, var int: n, int: base) =
   let { int: len = length(a) }
   in
   n = sum(i in 1..len) (
      ceil(pow(int2float(base), int2float(len-i))) * a[i]
   )
;


solve :: int_search(
        [x[i,j] | i in 0..rows-1, j in 0..cols-1], % ++ y, 
        first_fail, 
        indomain_min, 
        complete) 
    % maximize(sum(y));
    % minimize(sum(y));
    % minimize max_val;
    satisfy;

% solve satisfy;


%
% the constraints
%
constraint
  trace("base: " ++ show(base) ++ 
        " rows: " ++ show(rows) ++ 
        " cols: " ++ show(cols) ++ 
        " m1: " ++ show(m1) ++ 
        " m2: " ++ show(m2) ++ 
        " extra1: " ++ show(extra1) ++
        " extra2: " ++ show(extra2) ++
        % " sub_max: " ++ show(sub_max) ++ 
        "\n", 1=1)
;


constraint
   assert(m1 <= rows /\ m2 <= cols,
         "m1 and m1 must be <= rows and cols")
;


%
% mirror first->last columns/rows
%
constraint
   forall(i in 0..rows-1+extra1) (
      forall(j in 0..extra2-1) (
        x[i,j+cols] = x[i,j]
      )
   )
   /\
   forall(j in 0..cols-1+extra2)( 
      forall(i in 0..extra1-1) (
        x[i+rows,j] = x[i,j]
      )
   )
;

%
% semi-experimental: 
%   Replace the "y hack" since it restricts the range of dimensions.
%   So this can handle larger problems.
%
%   (On the other hand, using y and alldifferent(y) "drives" the solution
%   faster and don't require long flattening pre-process...)
% 
constraint
  forall(i1,i2 in 0..rows-1, j1,j2 in 0..cols-1 where i1 < i2 \/ j1 < j2) (
      sum(k1 in 0..m1-1, k2 in 0..m2-1) ( 
           bool2int(x[i1+k1, j1+k2] != x[i2+k1, j2+k2])
      ) >= 1
  )
;


%
% Use "y" to be able to use alldifferent(y).
%
% Note: When this is active, it's recommended that the "poor-man's" 
% alldifferent version above is commented out.
%
% For smaller matrices and with small base this is the recommended
% approach.
%
% constraint
%   forall(i in 0..rows-1, j in 0..cols-1) (
%      toNum([ x[i+k1, j+k2] | k1 in 0..m1-1, k2 in 0..m2-1], y[i*cols+j], base)
%   )
%   /\ % now we ensure that the 
%      % converted sub grids are unique
%      % Note: using ":: domain" annotation may require 
%      % _very_ much memory (lots of Gigs) for larger problems. 
%      % So don't.
%   alldifferent(y) % :: domain

%   % symmetry breaking
%   % /\ y[0] = 0
%   % /\ y[0] = sub_max
% ;


% %
% % extra constraints 
% % - global cardinality: the same number of occurrences for all values 0..base-1
%
% constraint
%    % global cardinality count
%    global_cardinality_old([x[i,j] | i in 0..rows-1, j in 0..cols-1], gcc)
%    % global_cardinality([x[i,j] | i in 0..rows-1, j in 0..cols-1], set2array(0..base-1),  gcc)

%    /\ % require that all occurrences of values in x should be the same.
%    forall(i in 1..base-1) (
%       gcc[i-1] = gcc[i]
%    )
% ;

% constraint maximum(max_val, y);

% require that all values > 0
% constraint forall(i,j in 0..dim-1) ( x[i,j] > 0 );

%
% require that all rows/columns (0..dim-1) are distinct
% (and - perhaps - diagonals), i.e. a Latin Square/Sudoku.
%
% int: reg = ceil(sqrt(int2float(rows))); % size of the Sudoku regions
% constraint
%   forall(i in 0..rows-1) ( 
%      alldifferent([x[i,j] | j in 0..cols-1])
%   )
%   /\
%   forall(j in 0..cols-1) (
%      alldifferent([x[i,j] | i in 0..rows-1])
%   )

%   % all subgrids are distinct (very experimental)
%   % /\
%   %   forall(i in 0..rows-1, j in 0..cols-1) (
%   %     alldifferent([ x[i+k1, j+k2] | k1 in 0..m1-1, k2 in 0..m2-1])
%   %   )
  

%   % diagonals and Sudoku sub-grids (if a square)
%   /\
%   if rows = cols then
%     % diagonal
%     alldifferent([x[i,i] | i in 0..rows-1])
%     /\ % diagonal
%     alldifferent([x[i,rows-i] | i in 0..rows-1])  

%     /\
%     if rows = 9 /\ cols = 9 then
%       % Require Sudoku sub grids
%       forall(i in 0..reg-1,j in 0..reg-1) (
%         % trace(show([1+r*cols+c | r in i*reg..(i*reg)+reg-1, c in j*reg..(j*reg)+reg-1]) ++ "\n", 1=1)
%         % /\
%         alldifferent([x[r,c] | r in i*reg..(i*reg)+reg-1, c in j*reg..(j*reg)+reg-1])
%       )
%      else 
%        true
%      endif
%    else 
%      true
%    endif
% ;


%
% A lot of information is printed.
%
output
[
 "x: " ++ show([x[i,j] | i in 0..rows-1, j in 0..cols-1]) ++ "\n"
]
++
["x (rows x cols):" ]
++
[
   if j = 0 then "\n" else " " endif ++
     show(x[i,j])
   | i in 0..rows-1, j in 0..cols-1
] 
++
["\n\nx expanded (rows-1+extra x cols-1+extra):" ]
++
[
   if j = 0 then "\n" else " " endif ++
     show(x[i,j])
   | i in 0..rows-1+extra1, j in 0..cols-1+extra2
] 
++
[
  "\n\nx as " ++ show(m1) ++ " x " ++ show(m2) ++ " m-tuples:\n"
]
++
[
  show([ x[i+k1, j+k2] | k1 in 0..m1-1, k2 in 0..m2-1]) ++  
       " y[" ++ show(i*cols+j) ++ "]: " ++ "\n" % ++ show(y[i*cols+j]) ++  "\n"
  | i in 0..rows-1, j in 0..cols-1
] 
%++
% ["\n\ny: " ++ show(y) ++ "\n"]
% ++
% [
%   if j = 0 then "\n" else " " endif ++
%     if fix(y[i*cols+j]) < 10 then " " else "" endif ++
%       show(y[i*cols+j])
%   | i in 0..rows-1, j in 0..cols-1
% ]
% ++ ["\n\ngcc: " ++ show(gcc) ++ "\n" ]
% ++ ["\n\nmax_val: " ++ show(max_val) ++ "\n" ]
++
["\n"]
;