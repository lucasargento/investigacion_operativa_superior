include "globals.mzn";

% number of units of gel paint
var int: gel;
% number of units of acrylic paint
var int: acrylic;

% units of paint must be non-negative
constraint gel >= 0;
constraint acrylic >= 0;

% 290 hours are available for producing raw materials
% it takes 4 hours to produce the raw materials for gel paint and 2 hours to produce the raw materials for acrylic paint
constraint 4 * gel + 2 * acrylic <= 290;

% 480 hours are available for mixing
% it take 3 hours to mix gel paint and 5 hours to mix acrylic paint
constraint 3 * gel + 5 * acrylic <= 480;

% 510 hours are available for packing
% it take 6 hours to pack gel paint and 2.3 hours to pack acrylic paint
constraint 6 * gel + 2.3 * acrylic <= 510;

% the profit per unit of gel is $80 and the profit per unit of acrylic is $200
var int: profit = 80 * gel + 200 * acrylic;

% maximize profit
solve maximize profit;

% Output
output ["Gel: " ++ show(gel) ++ "\nAcrylic: " ++ show(acrylic) ++ "\nProfit: " ++ show(profit)];