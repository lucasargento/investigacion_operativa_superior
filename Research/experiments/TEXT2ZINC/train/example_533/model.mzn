int: num_weights;
array[1..num_weights] of float: weights;
array[1..num_weights] of int: weight_avail;
int: req_weights;
float: bell_weight;
string: bell_type;


% decision variables
array[1..num_weights] of var 0..9: x;

var float: total = bell_weight + sum([x[i]*2*weights[i] | i in 1..num_weights]);
var int: num_selected_weights = sum([x[i] | i in 1..num_weights]);

solve satisfy;
% solve minimize num_selected_weights; % for minimizing the number of selected plates
% solve maximize total; % what't the largest total weight
% solve :: int_search(x, input_order, indomain_min, complete) satisfy;

constraint
  % ensure that we have enough couples of weight plates
  forall(w in 1..num_weights) (
     x[w] <= weight_avail[w]
  )
;

% Calculate the total weight (including weight of barbell/dumbbell)
constraint total = 52;

output [
  "\ntotal: \(total)kg\nnum_selected_weights: \(num_selected_weights)\n" ++
  "x: \(x)\n\n" ++
  "Weight of " ++ bell_type ++ ": \(bell_weight)kg\n" ++
  "Weights per side (reversed order):\n"
]
++
[
  if fix(x[num_weights-w+1]) > 0 then
    "\(x[num_weights-w+1]) of \(weights[num_weights-w+1])kg\n"
  else 
    ""
  endif
  | w in 1..num_weights
]
;

%
% Data.
% See the datafiles mentioned above...
%

%%
%% Barbell weights.
%%
%% Note: In order to work, one must have a _pair_ of weight plates, i.e. one of 
%% each side of the barbell. If you have four 2kg plates, then it's 
%%  represented as a 2 in weight_avail
%%
% bell_type = "barbell";
% num_weights = 10; % total number of weights
% req_weights = 2; % 2 weight plates in total (one of each side)
%% the weights (in kg)
%weights =      [0.50,1.0,1.25,2.0,2.5,5.0,10.0,20.0,25.0,50.0];
% % number of weight plates available
% % E.g. I have 4 plates of 0.5kg -> 2 in weight_avail, and 2 weights of 10kg -> 1.
%weight_avail = [   2,  2,  2,   2,  1,  2,   1,   0,   0,   0];  
% bell_weight = 7.0;



%%
%% Dumbbell weights.
%%
%% Note: In order to work, one must have four weight plates for a certain
%% weight, i.e. one plate of each side of the dumbbell, and we have two dumbbells.
%% If you have four 2kg plates, then it's represented as a 1 in weight_avail.
%%
% bell_type = "dumbbell";
% num_weights = 10; % total number of weights
% req_weights = 4; % 4 weights in total (two dumbbells and two on each barbell)
% % the weights (in kg)
% weights =      [0.50,1.0,1.25,2.0,2.5,5.0,10.0,20.0,25.0,50.0];
%% number of weight plates available. Divide the total number of weight plates by 4 
%% Eg. I have 12 0.5kg weights -> 3 in weight_avail, and 4 1.0kg weights (-> 1), etc.
% weight_avail = [   3,  1,  1,   1,  0,  1,   0,   0,   0,   0];  
% bell_weight = 1.5;