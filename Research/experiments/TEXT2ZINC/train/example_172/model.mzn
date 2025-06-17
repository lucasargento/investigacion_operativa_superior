int: num_movies;
array[1..num_movies, 1..2] of int: data;
array[1..num_movies] of string: movies;

% decision variables
array[1..num_movies] of var 0..1: x;
var 0..num_movies: z = sum(x);

% solve satisfy;
% solve maximize z;
solve :: int_search(x, first_fail, indomain_min, complete) maximize z;

predicate no_overlap(int: start1, int: end1, int: start2, int: end2) =
   start1 > end2 
   \/
   start2 > end1
;


constraint
  % z = 4 %% for solve satisfy
  % /\
  forall(i, j in 1..num_movies where i < j) (
     (x[i] = 1 /\ x[j] = 1) -> no_overlap(data[i,1], data[i,2], data[j,1], data[j,2])
  )
;

output 
[
  "z: " ++ show(z) ++ "\nx: " ++ show(x) ++ "\n"
]
++
[
  if fix(x[i]) = 1 then
    show(movies[i]) ++ ": " ++ show(data[i,1]) ++ ".." ++ show(data[i,2]) ++ "\n"
  else 
   ""
  endif 
  | i in 1..num_movies
];

%
% data
%
num_movies = 9;
data = array2d(1..num_movies, 1..2,
[
 4,13, % "Tarjan of the Jungle",
17,27, % "The Four Volume Problem",
 1,10, % "The President's Algorist",
12,18, % "Steiner's Tree",
23,30, % "Process Terminated",
 9,16, % "Halting State",
19,25, % "Programming Challenges",
 2, 7, % "'Discrete' Mathematics",
26,31  % "Calculated Bets"
]);

movies = [
"Tarjan of the Jungle",
"The Four Volume Problem",
"The President's Algorist",
"Steiner's Tree",
"Process Terminated",
"Halting State",
"Programming Challenges",
"'Discrete' Mathematics",
"Calculated Bets"
];