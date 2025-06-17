% Parameters
int: K = 3; % Number of industries
int: T = 5; % Number of years
set of int: INDUSTRIES = 1..K;
set of int: YEARS = 1..T;

% Input data
array[INDUSTRIES, INDUSTRIES] of float: inputone;
array[INDUSTRIES] of float: manpowerone;
array[INDUSTRIES, INDUSTRIES] of float: inputtwo;
array[INDUSTRIES] of float: manpowertwo;
array[INDUSTRIES] of int: stock;
array[INDUSTRIES] of int: capacity;
array[INDUSTRIES] of float: demand;

% Decision variables
array[INDUSTRIES, YEARS] of var 0..capacity[INDUSTRIES]: produce;
array[INDUSTRIES, YEARS] of var 0..capacity[INDUSTRIES]: buildcapa;
array[INDUSTRIES, YEARS] of var 0..capacity[INDUSTRIES]: stockhold;

% Constraints
constraint forall(k in INDUSTRIES, t in YEARS) (
    produce[k, t] + buildcapa[k, t] <= capacity[k]
);

constraint forall(k in INDUSTRIES, t in YEARS) (
    produce[k, t] + stockhold[k, t] >= demand[k]
);

constraint forall(k in INDUSTRIES, t in YEARS diff {1}) (
    stockhold[k, t] = stockhold[k, t-1] + produce[k, t-1] - demand[k]
);

constraint forall(k in INDUSTRIES, t in YEARS diff {1, 2}) (
    capacity[k] = capacity[k] + buildcapa[k, t-2]
);

% Objective function
var float: total_manpower;
constraint total_manpower = sum(k in INDUSTRIES, t in YEARS) (
    produce[k, t]*manpowerone[k] + buildcapa[k, t]*manpowertwo[k]
);
solve maximize total_manpower;