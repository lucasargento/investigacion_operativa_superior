int: weeks = 4;
int: groups = 3;
int: groupSize = 3;
int: golfers = groups * groupSize;

set of int: Golfer = 1..golfers;
set of int: Week = 1..weeks;
set of int: Group = 1..groups;

% Search space: The set of all possible group assignments to all 
% players in each of the weeks
array[Golfer, Week] of var Group: assign;

% solve satisfy;
% solve :: int_search([assign[i,j] | i in Golfer, j in Week ], "first_fail", "indomain", "complete") satisfy;
solve :: int_search([assign[i,j] | i in Golfer, j in Week ], 
        first_fail, indomain_min, complete) satisfy;

constraint
   % C1: Each group has exactly groupSize players
   forall (gr in Group, w in Week)( % c1
     sum (g in Golfer) (bool2int(assign[g,w] = gr)) = groupSize
   )
   /\
   % C2: Each pair of players only meets at most once
   forall (g1, g2 in Golfer, w1, w2 in Week  where g1 != g2 /\ w1 != w2) (
     (bool2int(assign[g1,w1] = assign[g2,w1]) + bool2int(assign[g1,w2] = assign[g2,w2])) <= 1
   )
  /\
  % SBSA: Symmetry-breaking by selective assignment
  % On the first week, the first groupSize golfers play in group 1, the 
  % second groupSize golfers play in group 2, etc. On the second week, 
  % golfer 1 plays in group 1, golfer 2 plays in group 2, etc.
  forall(g in Golfer) (
    assign[g,1]=((g-1) div groupSize) + 1 % 
  )
  /\
  forall(g in Golfer where g <= groupSize)(
    assign[g,2]=g
  )

;

output [
  if j = 1 then "\n" else " " endif ++
  show(assign[i,j])
  | i in Golfer, j in Week
] ++ ["\n"];