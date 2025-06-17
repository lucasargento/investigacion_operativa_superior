var int: J; 
% number of process P
var int: P;

% number of processes are non-negative
constraint J >= 0;
constraint P >= 0;

% there can be at most 1500 units of water
% process J uses 8 units of water and process P uses 6 units of water
constraint 8*J + 6*P <= 1500;

% there can be at most 1350 units of pollution
% process J produces 3 units of pollution and process P produces 5 units of pollution
constraint 3*J + 5*P <= 1350;

% process J extracts 5 units of metal and process P extracts 9 units of metal
var int: metal = 5*J + 9*P;

% maximize the amount of metal extracted
solve maximize metal;

% output
output ["Process J: ", show(J), "\n", "Process P: ", show(P), "\n", "Max metal: ", show(metal)];