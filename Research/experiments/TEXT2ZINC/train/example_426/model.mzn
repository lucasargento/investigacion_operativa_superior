var int: manual_jacks;
% number of electric jacks
var int: electric_jacks;

% number of jacks must be greater than 0
constraint manual_jacks >= 0;
constraint electric_jacks >= 0;

% number of manual jacks is at most 6
constraint manual_jacks <= 6;
% number of manual jacks is at most 8
constraint manual_jacks <= 8;
% number of electric jacks is at most 15
constraint electric_jacks <= 15;
% number of electric jacks is at least 5
constraint electric_jacks >= 5;

% number of electric jacks must be greater than the number of manual jacks
constraint electric_jacks > manual_jacks;

% manual jacks can transport 15 boxes every hour and electric jacks can transport 25 boxes every hour
var int: boxes = 15 * manual_jacks + 25 * electric_jacks;

% maximize the number of boxes
solve maximize boxes;
output ["Manual Pallet Jacks: " ++ show(manual_jacks) ++ "\n" ++ "Electric Pallet Jacks: " ++ show(electric_jacks) ++ "\n" ++ "Max Boxes: " ++ show(boxes)];