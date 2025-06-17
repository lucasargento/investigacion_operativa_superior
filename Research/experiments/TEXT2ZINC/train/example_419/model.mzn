var int: tube_trailers;
% number of trips by hydrogen tanker
var int: hydrogen_tankers;

% trips are non-negative
constraint tube_trailers >= 0;
constraint hydrogen_tankers >= 0;

% the company needs to transport at least 1000 cubic meters of hydrogen
% high-pressure tube trailer can transport 50 cubic meters each per trip and hydrogen_tankers 30 cubic meters per trip
constraint tube_trailers * 50 + hydrogen_tankers * 30 >= 1000;
% they have budget of $ 3750 available
% cost of trip is 500 per tube trailer and 200 per hydrogen tanker
constraint tube_trailers * 500 + hydrogen_tankers * 200 <= 3750;

% the number of transports done by the high pressure tube trailer method has to be less than the number of transports done by the liquefied hydrogen tanker method
constraint tube_trailers < hydrogen_tankers;

% minimize total number of trips
solve minimize tube_trailers + hydrogen_tankers;

% output
output ["High Pressure Tube Trailers: " ++ show(tube_trailers) ++ "\nLiquefied Hydrogen Tankers: " ++ show(hydrogen_tankers)];