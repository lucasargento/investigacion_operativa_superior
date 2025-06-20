int: nb_buckets = 3;
int: max_step = 10; % 8 for satisfy
set of int: buckets = 1..nb_buckets;
set of int: steps = 1..max_step;
array[buckets] of int: capacity = [8,5,3];
array[buckets] of int: start = [8,0,0];
array[buckets] of int: goal = [4,4,0];

% Search space: The set of all possibile sequences of configurations (states), 
% where a configuration is a triple encoding the amount of water in each 
% bucket at a given time-step
array[steps, buckets] of var int: state;
var 1..max_step: goal_step;

% Objective function
solve minimize goal_step;
% solve :: int_search( [ state[i,j] | i in steps, j in buckets ] , "first_fail", "indomain", "complete")  minimize goal_step;

constraint
%   goal_step <= 8 % for solve satisfy
%   /\
   % assertions
   forall(b in buckets) (
      (start[b] <= capacity[b]) /\ (goal[b] <= capacity[b])
   )
   /\
   sum(b in buckets)(start[b]) = sum(b in buckets)(goal[b])
   /\
   forall(s in steps, b in buckets) (
      state[s,b] >= 0 /\
      state[s,b] <= capacity[b]
   )
   /\
   forall(b in buckets) (
      % C1: At beginning, buckets contain the amount of water specified by function start
      state[1,b]=start[b]
      /\
      % C2: At the end, buckets contain the amount of water specified by function goal
      state[goal_step,b] = goal[b]
   )
   /\
   forall(step in 1..max_step-1) (
      % C3: The configuration at each step differs from that of the next one in that the amount of
      % water of exactly 2 buckets changes (that in the others remain the same)
      sum(b in buckets)( bool2int(state[step,b] != state[step+1, b])) = 2
      /\
      % C4: The overall amount of water is the same at each time step
      sum(b in buckets)(state[step,b]) = sum(b in buckets)(state[step+1,b])
      /\

      % C5: After each transition (involving buckets b1 and b2), either the source
      % bucket becomes empty, or the target becomes full
      forall(b1, b2 in buckets where b1 != b2) (
         ((state[step, b1] != state[step+1, b1]) /\ (state[step, b2] != state[step+1, b2])) ->
            (state[step+1,b1] = 0 \/ state[step+1,b1] = capacity[b1] \/
             state[step+1,b2] = 0 \/ state[step+1,b2] = capacity[b2])
     )
   )
;


output [
  if s = 1 /\ b = 1 then 
    "goal_step: " ++ show(goal_step)
  else "" endif ++
  if b = 1 then "\n" else " " endif ++
  show(state[s, b])
  | s in steps, b in buckets

] 
++ ["\n"];