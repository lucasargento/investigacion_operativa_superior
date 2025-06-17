var int: boat_trips;
% number of neighbor trips
var int: neighbor_trips; 

% number of trips are non-negative
constraint boat_trips >= 0;
constraint neighbor_trips >= 0;

% man does not want to spend more than $500
% boat trips cost $30 and trips by his neighbor cost 8
constraint 30 * boat_trips + 8 * neighbor_trips <= 500;

% number of boat trips can not exceed the number of trips his neighbor does
constraint boat_trips <= neighbor_trips; 

% units of berries boat trips can take is 200 and trips by his neight can take is 40
var int: berries = 200 * boat_trips + 40 * neighbor_trips;

% maximize number of berries
solve maximize berries;

% output the solution
output ["boat_trips: ", show(boat_trips), "\n", "neighbor_trips: ", show(neighbor_trips)];