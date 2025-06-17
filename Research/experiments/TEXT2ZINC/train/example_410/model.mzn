include "globals.mzn";

% acres of net fishing
var int: net_acres;
% acres of line fishing
var int: line_acres;

% acres of fishing are non-negative
constraint net_acres >= 0;
constraint line_acres >= 0;

% the lake is 250 acres
constraint net_acres + line_acres <= 250;
% 800 units of bait are available
% net fishing requires 4 units of bait per acre, line fishing requires 3 units of bait per acre
constraint 4*net_acres + 3*line_acres <= 800;
% can tolerate 350 units of pain
% net fishing requires 2 units of pain per acre, line fishing requires 1 unit of pain per acre
constraint 2*net_acres + line_acres <= 350;

% net fishing catches 8 fish per acre and line fishing catches 5 fish per acre
var int: total_fish = 8*net_acres + 5*line_acres;

% maximize total fish
solve maximize total_fish;

output ["Net Acres: " ++ show(net_acres), "\n", "Line Acres: " ++ show(line_acres), "\n", "Total Fish: " ++ show(total_fish)];