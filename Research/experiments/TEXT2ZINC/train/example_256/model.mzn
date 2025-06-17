% Parameters
int: num_years;
set of int: YEARS = 1..num_years;
set of int: MANPOWER = 1..3;

array[MANPOWER, YEARS] of int: requirement;
array[MANPOWER] of int: strength;
array[MANPOWER] of float: lessonewaste;
array[MANPOWER] of float: moreonewaste;
array[MANPOWER] of int: recruit;
array[MANPOWER] of int: costredundancy;
int: num_overman;
array[MANPOWER] of int: costoverman;
int: num_shortwork;
array[MANPOWER] of int: costshort;

% Decision Variables
array[MANPOWER, YEARS] of var 0..recruit[MANPOWER]: recruit_year;
array[MANPOWER, YEARS] of var 0..num_overman: overmanning_year;
array[MANPOWER, YEARS] of var 0..num_shortwork: short_year;

% Constraints
constraint forall(k in MANPOWER, i in YEARS)(
  if i = 1 then
    strength[k] + recruit_year[k,i] - overmanning_year[k,i] - short_year[k,i] = requirement[k,i]
  else
    (1 - moreonewaste[k]) * (strength[k] + sum(j in 1..(i-1))(recruit_year[k,j] - overmanning_year[k,j] - short_year[k,j])) + recruit_year[k,i] - overmanning_year[k,i] - short_year[k,i] = requirement[k,i]
  endif
);

% Objective
var int: total_cost = sum(k in MANPOWER, i in YEARS)(costredundancy[k] * recruit_year[k,i] + costoverman[k] * overmanning_year[k,i] + costshort[k] * short_year[k,i]);
solve minimize total_cost;

% Output
output ["recruit: ", show(recruit_year), "\n", "overmanning: ", show(overmanning_year), "\n", "short: ", show(short_year)];