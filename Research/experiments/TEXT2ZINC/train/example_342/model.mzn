int: num_persons; %  = 4;
int: max_time; % = 10; % max number of time slots
int: max_num_to_cross; % = 2; % maximum number of people to cross at the same time
int: A = 1; % all start here
int: B = 2; % all ends here

% time to cross the bridge
array[1..num_persons] of int: cross_time; %  = [1,2,5,8];

% the actions: who moves where?
array[1..max_time, 1..num_persons] of var A..B: actions;

% how long did that move take?
array[1..max_time] of var 0..sum(cross_time): times;

% where is the torch at time t?
array[1..max_time] of var A..B: torch_place;

% number of steps to goal
var 1..max_time: total_steps;

% total time to goal (to minimize)
var int: total = sum(t in 1..max_time) ( times[t]*bool2int(t <= total_steps));

% which persons are transfered this time? (channeled to actions)
array[1..max_time] of var set of 1..num_persons: transfered;

% solve minimize total;
solve :: 
      int_search(
        [actions[i,j] | i in 1..max_time, j in 1..num_persons] ++ 
        times ++ 
        torch_place ++
        [total_steps, total], 
        occurrence, % largest, % occurrence, 
        indomain_min, 
        complete) 
     minimize total_steps
     % satisfy
    ;

constraint

   % initiation 
   forall(i in 1..num_persons) (
      actions[1,i] = A
   )
   /\
   torch_place[1] = A
   /\
   transfered[1] = 1..num_persons


   /\ % the transfers
   forall(t in 2..max_time) (

     % find where the torch where the last time
     exists(place in A..B) (      

       % where where the torch?
       torch_place[t-1] = place

       /\ % the torch should alternate
       torch_place[t] != torch_place[t-1]
       /\
       let {
           % number of transfered this time
           var 1..max_num_to_cross: num_transfered = card(transfered[t])
       } 
       in
       
       % time of this transfer is the maximum value (slowest person)
       times[t] = max(i in 1..num_persons) (
                     cross_time[i]*bool2int(
                              i in transfered[t]
                           )
                   )
       /\ % channel transfered <=> actions
       forall(i in 1..num_persons) (
          ((i in transfered[t]) <-> (
                                     actions[t-1,i] = place /\
                                     actions[t-1,i] != actions[t,i]
                                 ))
          /\
          (not(i in transfered[t]) <-> actions[t-1,i] = actions[t,i])
       )
     ) % end exists

   )

   /\ % the goal
   exists(t in 2..max_time) (
      % all on the B side
      forall(i in 1..num_persons) (
          actions[t, i] = B
      )
      /\
      torch_place[t] = B
      /\
      total_steps = t

   )
   
   % for solve satisfy of original problem
   % /\ total <= 15 % for solve satisfy
   % /\ total_steps <= 6
;


output
[
   "total_steps: " ++ show(total_steps) ++ "\n" ++
   "total: " ++ show(total)
]
++
[
  if p = 1 /\ t <= fix(total_steps) then "\n" else " " endif ++
    if t <= fix(total_steps) then
       show(actions[t,p]) ++ 
       if p = num_persons 
            then " torch: " ++ show(torch_place[t]) ++ " transfered: " ++ show(transfered[t])
       else "" endif
    else "" endif
  | t in 1..max_time, p in 1..num_persons
]
;