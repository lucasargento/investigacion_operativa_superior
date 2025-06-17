include "globals.mzn";

% number of trips by delivery truck and van
var int: truck;
var int: van;

% transporting by delivery truck costs $300 per trip and transporting by van costs $200 per trip
var int: total_cost = truck * 300 + van * 200;

% transporting by delivery truck takes 12 hours and transporting by van takes 10 hours
var int: total_time = truck * 12 + van * 10;

% trips must be non-negative
constraint truck >= 0;
constraint van >= 0;

% the researcher has a budget of 5500
constraint total_cost <= 5500;
% the number of transports by the delivery truck must be less than the number of transports by van
constraint truck < van;
% the researcher needs to transport 20 trips worth of equipment
constraint truck + van = 20;

% Objective
solve minimize total_time;

% Output
output ["Truck: " ++ show(truck) ++ "\nVan: " ++ show(van)];