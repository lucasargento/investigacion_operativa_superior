var int: helicopters; 
% number of truck trips
var int: trucks;

% number of trips are non-negative
constraint helicopters >= 0;
constraint trucks >= 0;

% the farmer needs to transport 80 cows
% a helicopter can take 3 cows per trip and a truck can take 7 cows per trip
constraint 3*helicopters + 7*trucks >= 80;

% helicopter trips cause 5 units of pollution and truck trips cause 10 units of pullution
var int: pollution = 5*helicopters + 10*trucks;

% he only has enough money for at most 8 truck trips
constraint trucks <= 8;

% minimize pollution
solve minimize pollution;

% Output the solution
output ["Number of helicopter trips: " ++ show(helicopters) ++ "\n" ++ "Number of truck trips: " ++ show(trucks)];