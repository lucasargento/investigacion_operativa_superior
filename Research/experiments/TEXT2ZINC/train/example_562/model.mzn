int: num_ingredients = 3;
int: num_feeds       = 3;
array[1..num_ingredients, 1..num_feeds] of int: ingredients_per_feed = 
      array2d(1..num_ingredients, 1..num_feeds, [90, 20, 40,
                                                 30, 80, 60,
                                                 10, 20, 60]);
array[1..num_feeds] of int: feed_cost = [84,72,60]; % in cents
array[1..num_ingredients] of int: min_daily_requirements = [200, 180,150];

% mix of feeds
array[1..num_feeds] of var 0..100: mix;
% total cost
var 0..1000: tot_cost;
% which daily requirements are met?
array[1..num_ingredients] of var 0..1: daily_req_met;

solve minimize tot_cost;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint
    % daily requirements
    forall(i in 1..num_ingredients) (
      % hard constraint version
      % sum(j in 1..num_feeds) (mix[j]*ingredients_per_feed[i,j]) >= min_daily_requirements[i]

      % soft constraint version according to requirement 3.
      (sum(j in 1..num_feeds) (mix[j]*ingredients_per_feed[i,j]) >= min_daily_requirements[i]) <-> (daily_req_met[i] = 1)
    )
    /\
    tot_cost = sum(j in 1..num_feeds) ( mix[j]*feed_cost[j])
    
    %  2. Suppose the farmer wants to have at most 2 feed types in the mix. 
    %     Modify the model of part (a) to take the new restriction into account.
    /\ sum(j in 1..num_feeds) (bool2int(mix[j] > 0)) <= 2

    %  3. The farmer thinks that satisfying all the nutritional requirements costs him 
    %     too much. He wants to keep only two of the three requirements. Modify the model 
    %     of part (a) to minimize the cost while satisfying only two (any two) of the 
    %     three nutritional requirements.
    /\ sum(daily_req_met) = 2
;


output
[
  "mix: " ++ show(mix) ++ "\n" ++
  "tot_cost: " ++ show(tot_cost) ++ "\n" ++
  "daily_req_met: " ++ show(daily_req_met) ++ "\n"
 
];