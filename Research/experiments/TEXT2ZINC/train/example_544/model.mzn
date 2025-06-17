include "globals.mzn"; 
int: num_p; % number of persons (excluding Evan)
int: num_r; % number of ratings (movies)

array[1..num_p, 1..num_r] of int: data;
array[1..num_r-1] of int: testcase; % Evans data
array[1..num_p] of string: p_str; % name of the people
int: the_case; % the index of the test case


% decision variables
% Note: we could use a single var 1..5: rate here
%       since we can compare using the testcase array.
%       However, I prefer to have all Evan's rating
%       collected...
array[1..num_r] of var 1..5: x;

% The distances between Evan and the others
array[1..num_p] of var 0..1000: dists;
% the minimum distance
var int: min_dist = min(dists);
% index of the minimum in min_dist
var 1..num_p: min_ix; 

% solve satisfy;
solve minimize min_dist;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

% 
% Calculate the distance between two persons.
% 
% Note: d is the the sum of squared distances but should be
%       the the square root of that sum. It doesn't matter here...
%
predicate dist(array[int] of int: a, array[int] of var int: v, var int: d) = 

      d = sum(i in index_set(a)) (
              (a[i]-v[i])*(a[i]-v[i])
          )
      /\ d >= 0
;

%
% min_index(ix, array)
%
% ix is the index of the minimum value in x (i.e. argmin).
% (I assume that the values are distinct...)
predicate min_index(var int: mi, array[int] of var int: x) =
  exists(i in index_set(x)) (
     x[i] = min(x) % minimum(x[i], x)
     /\
     mi = i 
  )
;


constraint

  % Fill in the known values of Evan
  forall(i in 1..num_r-1) (
     x[i] = testcase[i]
  )

  /\ % Calculate the distances between Evan (testcase, x) 
     % and other people.
  forall(p in 1..num_p) (
     dist([data[p,i] | i in 1..num_r-1], testcase, dists[p])
  )

  /\ % get the index of the person with the minimum distance 
  min_index(min_ix, dists)
  /\ % assign the value of that person's rating for movie 5
  x[the_case] = data[min_ix, the_case]
;

output [
 "x: " ++ show(x) ++ "\n" ++
 "dists: " ++ show(dists) ++ "\n" ++
 "probable rating: " ++ show(x[the_case]) ++ "\n" ++
 "min_ix: " ++ show(min_ix) ++ "\n" ++ 
 "Evan is most like " ++ show(p_str[fix(min_ix)]) ++ "\n"
]
 ++ ["\n"]
;

%
% Data
%
num_p = 4;
num_r = 5;
data = array2d(1..num_p, 1..num_r,
[
4,5,1,4,4,  % Alex
4,1,5,5,2,  % Bill
2,4,2,2,4,  % Carla
2,3,4,5,2,  % Dan
% 5,3,1,2,? % Evan % This is the one to test...
]);

p_str = ["Alex", "Bill", "Carla", "Dan"];

testcase = [5,3,1,2]; % Evan
the_case = 5; % I.e. the last movie