include "globals.mzn";

% number of bulldozers and forklifts
var int: bulldozers;
var int: forklifts;

% units are non-negative
constraint bulldozers >= 0;
constraint forklifts >= 0;

% 600 hours of assembly time are available
% bulldozers take 3 hours on the assembly line and forklifts take 2 hours
constraint bulldozers * 3 + forklifts * 2 <= 600;

% 400 hours of QC time are available
% bulldozers take 2 hours of QC time and forklifts take 1.5 hours
constraint bulldozers * 2 + forklifts * 1.5 <= 400;

% profit from bulldozers is 7000 each and from forklifts is 6000 each
var int: profit = bulldozers * 7000 + forklifts * 6000;

% maximize profit
solve maximize profit;

% Output
output ["Number of bulldozers: ", show(bulldozers), "\n", "Number of forklifts: ", show(forklifts), "\n", "Maximum profit: $", show(profit)];