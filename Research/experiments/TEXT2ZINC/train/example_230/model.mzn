% Define parameters
int: K; % Number of categories
int: I; % Number of years
array[1..K, 1..I] of int: requirement; % Manpower requirements
array[1..K] of int: strength; % Current strength of manpower
array[1..K] of float: lessonewaste; % Wastage rates of manpower with less than one year's service
array[1..K] of float: moreonewaste; % Wastage rates of manpower with more than one year's service
array[1..K] of int: recruit; % Number of workers that can be recruited
array[1..K] of int: costredundancy; % Redundancy payment
int: num_overman; % Maximum number of overmanned workers
array[1..K] of int: costoverman; % Extra cost per overmanned worker
int: num_shortwork; % Maximum number of short-time workers
array[1..K] of int: costshort; % Cost per short-time worker

% Define decision variables
array[1..K, 1..I] of var 0..recruit[1..K]: Recruit; % Number of recruits
array[1..K, 1..I] of var 0..num_overman: Overman; % Number of overmanned workers
array[1..K, 1..I] of var 0..num_shortwork: Short; % Number of short-time workers

% Define constraints
constraint forall(k in 1..K, i in 1..I) (
  if i = 1 then
    strength[k] + Recruit[k,i] - Overman[k,i] - Short[k,i] = requirement[k,i]
  else
    strength[k] + sum(j in 1..i)(Recruit[k,j]*(1 - lessonewaste[k])) - Overman[k,i] - Short[k,i] = requirement[k,i]
  endif
);

% Define objective function
var int: total_cost = sum(k in 1..K, i in 1..I) (
  costredundancy[k]*Recruit[k,i] + costoverman[k]*Overman[k,i] + costshort[k]*Short[k,i]
);

% Minimize total cost
solve minimize total_cost;

% Output
output [ "recruit: " ++ show(Recruit) ++ "\n" ++
         "overmanning: " ++ show(Overman) ++ "\n" ++
         "short: " ++ show(Short) ++ "\n" ];