include "globals.mzn";

% number of regular packages
var int: regular;
% number of premium packages
var int: premium;

% number of packages must be non-negative
constraint regular >= 0;
constraint premium >= 0;

% 9000 units of medicinal herbs are available
% a regular package requires 100 grams of medicinal herbs and a premium package requires 130 grams of medicinal herbs
constraint regular * 100 + premium * 130 <= 9000;

% 3500 seconds are available in the drying machine
% a regular package requires 30 seconds of drying time and a premium package requires 60 seconds of drying time
constraint regular * 30 + premium * 60 <= 3500;

% number of regular packages must be less than the number of premium packages
constraint regular < premium;

% the company must make at least 15 regular packages
constraint regular >= 15;

% a regular package can treat 2 people and a premium package can treat 3 people
var int: total_people = regular * 2 + premium * 3;

solve maximize total_people;

output ["Regular Packages: " ++ show(regular) ++ "\n", "Premium Packages: " ++ show(premium) ++ "\n", "Total People: " ++ show(total_people) ++ "\n"];