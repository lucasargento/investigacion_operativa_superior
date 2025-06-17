include "globals.mzn";

% Number of limousines and buses
var 0..100: limousines;
var 0..100: buses;

% they need to transport at least 400 people
% limousines can carry 12 people and buses can carry 18 people 
constraint limousines * 12 + buses * 18 >= 400;

% at least 70 % of the vehicles must be limousines
constraint limousines >= 0.7 * (limousines + buses);

% minimize the total number of limousines and buses used
solve minimize limousines + buses;

% output
output ["Number of limousines: ", show(limousines), "\n", "Number of buses: ", show(buses)];