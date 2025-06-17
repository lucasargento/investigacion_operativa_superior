include "globals.mzn"; 

int: num_days;
int: num_people;

% the days a person want to car pool (and perhaps drive)
array[1..num_people, 1..num_days] of int: participation;

array[1..num_days] of int: day_people = [sum([participation[p,d] | p in 1..num_people]) | d in 1..num_days ];

% the number of days a person should drive to be fair
array[1..num_people] of int: obligation = 
  [ceil(sum([1/day_people[d]*participation[p,d] | d in 1..num_days])) | p in 1..num_people];

int: obligation_diff = sum(obligation) - num_days;


% decision variables

% who will drive at day d
array[1..num_days] of var 1..num_people: driver;

% how many days drives person p
array[1..num_people] of var 1..num_days: num_drives;
array[1..num_people] of var 0..num_people div abs(num_days-sum(obligation)): diffs;

% the objective: number of discrepances between the
% actual driving and the number in obligation[p]
% var 0..num_people*num_days: z = sum(diffs);
var 0..obligation_diff: z = sum(diffs);

var 0..num_people*num_days: pdiff;

var int: mean = sum(diffs) div num_people;

% solve minimize z;
solve :: int_search(diffs ++ driver ++ num_drives, occurrence, indomain_median, complete) minimize pdiff;

constraint
  % person p don't drive no more than obligation[p] days per num_days
  forall(p in 1..num_people) (
    num_drives[p] = sum([bool2int(driver[d]=p)| d in 1..num_days])
    /\
    num_drives[p] <= obligation[p]
    /\
    diffs[p] = abs(obligation[p]-num_drives[p])
  )
  % /\ z = sum(obligation)-num_days
  /\
  z = obligation_diff
  /\
  pdiff = sum([abs(diffs[p1]-diffs[p2]) | p1,p2 in 1..num_people where p1 < p2])
  /\ % a person can only drive when (s)he participates
  forall(d in 1..num_days) (
    driver[d] in { p | p in 1..num_people where participation[p,d] = 1}
    % forall(p in 1..num_people where participation[p,d] = 0) (
    %   driver[d] != p
    % )
  )

  % symmetry breaking
  % /\ value_precede_chain([1,2,3,4,5,6,7,8], driver)

  % increasing(diffs)
;

output [
  "num_people: ", show(num_people), "\n",
  "num_people div abs(num_days-sum(obligation)): ", show(num_people div abs(num_days-sum(obligation))), "\n",
  "num_days: ", show(num_days), "\n",
  "oligation: ",show(obligation), "\n",
  "sum_oligation: ",show(sum(obligation)), "\n",
  "driver: ", show(driver), "\n",
  "num_drives: ", show(num_drives), "\n",
  "diffs: ", show(diffs), "\n",
  "mean: ", show(mean), "\n",
  "z: ", show(z), "\n",
  "pdiff: ", show(pdiff), "\n"
]
++ ["\nDays:\n"] ++
[
  "day " ++ show_int(2,d) ++ " driver: " ++ show(driver[d]) ++ "\n"
  | d in 1..num_days
]
++ ["\nPeople:\n"] ++
[
  "person" ++ show(p) ++ 
  " (obl: " ++ show(obligation[p]) ++ " drives: " ++ show(num_drives[p]) ++  if obligation[p] != fix(num_drives[p]) then "!" else "" endif ++ ") " ++
  " days: " ++ 
         show(join(",", [show(d) | d in 1..num_days where fix(driver[d]) = p])) ++ "\n"
  | p in 1..num_people
]
++ ["\nSchedule: 'X': drives, 'r': rides, '_': don't participates the day"] ++
[
  if d = 1 then "\n" else " " endif ++
    if fix(driver[d] = p) then "X" 
    elseif participation[p,d] = 1 then "r"
    else "_"
    endif
  | p in 1..num_people, d in 1..num_days
]
;


%
% data
%

% original problem: 1 week
% num_days = 5;
% num_people = 4;
% participation = array2d(1..num_people, 1..num_days,
%   [ 
%     % days 1 2 3 4 5
%            1,1,1,0,0, % p 1
%            1,0,1,0,0, % p 2
%            1,1,1,1,1, % p 3
%            0,1,1,1,1, % p 4
%   ]);