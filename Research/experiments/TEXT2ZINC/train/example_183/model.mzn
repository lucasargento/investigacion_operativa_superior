include "globals.mzn"; 
int: rows = 3;
int: cols = 3;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: max_int = E;

% string representation of the values 1..max_int
array[0..max_int] of string: str = array1d(0..max_int, ["_", "A","B","C","D","E"]);

% problem A (satifiable)
array[1..rows, 1..cols] of int: matrix = 
  array2d(1..rows, 1..cols,
    [
      A,B,0,
      E,D,C,
      A,B,C,
    ]);

% problem B (unsatisfiable)
% array[1..rows, 1..cols] of int: matrix = 
%   array2d(1..rows, 1..cols,
%     [
%       A,B,C,
%       A,B,D,
%       B,C,D,
%     ]);


% the valid values (we skip 0, zero)
set of 1..max_int: values = 
    { matrix[i,j] | i in 1..rows, j in 1..cols where matrix[i,j] != 0};

% identify the rows for a specific value.
% E.g. for problem A: 
%     value_rows: [{1, 3}, {1, 3}, 2..3, 2..2, 2..2]
array[1..max_int] of set of int: value_rows = 
   [ {i | i in 1..rows, j in 1..cols where matrix[i,j] = v} | v in values];

% Show the value_rows
% constraint trace("value_rows: " ++ show(value_rows) ++ "\n", 1=1);

%
% decision variables
%

% The resulting matrix
array[1..rows, 1..cols] of var 0..max_int: x;

% the permutations from matrix to x
array[1..rows, 1..cols] of var 1..max_int: perms;

%
% permutation3(a,p,b) 
% get the permutation from a <-> b using the permutation p.
%
predicate permutation3(array[int] of var int: a,
                       array[int] of var int: p,
                       array[int] of var int: b) =
   forall(i in index_set(a)) (
       b[i] = a[p[i]]
   )
;
   
% solve satisfy;
solve :: int_search(
      [x[i,j] | i in 1..rows, j in 1..cols], 
      first_fail, 
      indomain_min, 
      complete) 
   satisfy;


constraint
  forall(i in 1..rows) (
    alldifferent_except_0([x[i,j] | j in 1..cols]) /\
    alldifferent([perms[i,j] | j in 1..cols]) /\
    permutation3([matrix[i,j] | j in 1..cols], 
                 [perms[i,j] | j in 1..cols], 
                 [x[i,j] | j in 1..cols])
  )
  /\ % zeros in "x" at the same place as in "matrix"
  forall(i in 1..rows, j in 1..cols) (
     if matrix[i,j] = 0 then x[i,j] = 0 else true endif
  )
  
  /\ 
  % ensure that same values are in the same column for all rows
  % forall(k in values) (
  %    exists(j in 1..cols) (
  %      forall(i in value_rows[k]) (
  %         x[i,j] = k 
  %      )
  %    )
  % )
  % alternative: using a temp variable instead of exists
  % (might be faster)
  forall(k in values) (
     let { var 1..cols: j } in
     forall(i in value_rows[k]) ( x[i,j] = k )
  )

  % /\ % symmetry breaking (experimental!)
  % increasing([x[rows,j] | j in 1..cols])

;

output 
["matrix:\n"] ++
[
   if j = 1 then "\n" else " " endif ++ 
      show(matrix[i,j])
    | i in 1..rows, j in 1..cols
] 
++["\nperms:\n"] ++
[
    if j = 1 then "\n" else " " endif ++ 
      show(perms[i,j])
    | i in 1..rows, j in 1..cols
]
++ ["\nx:\n"] ++
[
   if j = 1 then "\n" else " " endif ++ 
    show(str[fix(x[i,j])])
    | i in 1..rows, j in 1..cols
];