include "globals.mzn"; 

int: num_kids;
array[1..num_kids, 1..3] of int: prefs;

int: num_activities;
array[1..num_activities] of int: activity_size;

% decision variables
array[1..num_kids] of var 1..num_activities: x; % the selected activity
array[1..num_kids] of var 1..num_activities: scores;

var int: total_score = sum(scores);

solve maximize total_score;
% solve satisfy;
% solve :: int_search(x ++ scores, first_fail, indomain_split, complete) maximize total_score;

constraint
  forall(k in 1..num_kids) (
    % select one of the prefered activities

    % exists(p in 1..3) (
    %   x[k] = prefs[k,p] /\
    %   scores[k] = 4-p % score for the selected activity
    % )
    % alternative:
    let {
      var 1..3: p
    } in 
      x[k] = prefs[k,p] /\
      scores[k] = 4-p % score for the selected activity
  )

  /\ % ensure size of the activities
  % 
  % forall(a in 1..num_activities) (
  %  sum([bool2int(x[k] = a) | k in 1..num_kids]) <= activity_size[a]
  % )

  global_cardinality_low_up(x, [i | i in 1..num_activities], [0 | i in 1..num_activities], activity_size)

  % /\ total_score = 17 % for solve satisfy and the second activity_size

;

output [
  "x     : ", show(x), "\n",
  "scores: ", show(scores), "\n",
  "total_score: ", show(total_score), "\n",

];

%
% some small fake data
%
num_kids = 6;
num_activities = 4;

% Activity preferences for each kid
prefs = array2d(1..num_kids, 1..3,
[
  1,2,3,
  4,2,1,
  2,1,4,
  4,2,1,
  3,2,4,
  4,1,3
]);

% max size of activity
activity_size = [2,2,2,3];
% activity_size = [2,2,2,2];