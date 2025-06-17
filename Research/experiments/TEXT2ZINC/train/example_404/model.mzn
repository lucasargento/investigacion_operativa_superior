include "globals.mzn";

% number of card-based machines
var int: card_machines;
% number of coin-based machines
var int: coin_machines;

% number of each machine must be non-negative
constraint card_machines >= 0;
constraint coin_machines >= 0;

% total number of guests accepted per hour must be greater than 1500
% card machines can accept 60 guests per hour and coin machines can accept 45 guests per hour
constraint card_machines * 60 + coin_machines * 45 >= 1500;

% total units of electricity used per hour must be less than 145
% card machines use 6 units of electricity per hour and coin machines use 4 units of electricity per hour
constraint card_machines * 6 + coin_machines * 4 <= 145;

% the number of card machines must be greater than the number of coin machines
constraint card_machines > coin_machines;

% minimize total machines
var int: total_machines = card_machines + coin_machines;
solve minimize total_machines;

% Output
output ["Number of card-based machines: " ++ show(card_machines) ++ "\nNumber of coin-based machines: " ++ show(coin_machines)];