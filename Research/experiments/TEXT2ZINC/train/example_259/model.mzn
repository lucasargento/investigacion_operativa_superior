% Define parameters
int: num_industries = 3;
int: num_years = 5;
set of int: Industries = 1..num_industries;
set of int: Years = 1..num_years;

% Input data
array[Industries, Industries] of float: inputone;
array[Industries] of float: manpowerone;
array[Industries, Industries] of float: inputtwo;
array[Industries] of float: manpowertwo;
array[Industries] of float: stock;
array[Industries] of float: capacity;
float: manpower_limit;
array[Industries] of float: demand;

% Decision variables
array[Industries, Years] of var 0.0..manpower_limit: produce;
array[Industries, Years] of var 0.0..manpower_limit: buildcapa;
array[Industries, Years] of var 0.0..manpower_limit: stockhold;

% Constraints
constraint forall(i in Industries, t in Years) (
    produce[i,t] + buildcapa[i,t] <= capacity[i] + if t > 2 then buildcapa[i,t-2] else 0 endif
);

constraint forall(i in Industries, t in Years) (
    produce[i,t] + buildcapa[i,t] + stockhold[i,t] = 
    if t > 1 then stockhold[i,t-1] else stock[i] endif + 
    sum(j in Industries) (produce[j,t] * inputone[j,i])
);

constraint forall(t in Years) (
    sum(i in Industries) (produce[i,t] * manpowerone[i] + buildcapa[i,t] * manpowertwo[i]) <= manpower_limit
);

constraint forall(i in Industries, t in Years) (
    produce[i,t] >= demand[i]
);

% Objective function
var float: total_capacity = sum(i in Industries) (capacity[i] + sum(t in 3..num_years) (buildcapa[i,t]));
solve maximize total_capacity;

% Output
output ["produce: ", show(produce), "\n", "buildcapa: ", show(buildcapa), "\n", "stockhold: ", show(stockhold)];