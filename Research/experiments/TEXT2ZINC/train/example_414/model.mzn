include "globals.mzn";

% number of UI designers
var int: UI_designers;
% number of software engineers
var int: software_engineers;

% workers are non-negative
constraint UI_designers >= 0;
constraint software_engineers >= 0;

% at least 10 software engineers
constraint software_engineers >= 10;
% at least 50 workers
constraint UI_designers + software_engineers >= 50;
% the number of software engineers should be at least a third of the number to UI designers
constraint software_engineers >= UI_designers / 3;

% UI designers earn $2500 per week and software engineers earn $2000 per week 
var int: wage_bill = 2500 * UI_designers + 2000 * software_engineers;
constraint wage_bill <= 200000;

% minimize wage bill
solve minimize wage_bill;

% Output
output ["UI_designers: ", show(UI_designers), "\n", "software_engineers: ", show(software_engineers), "\n", "wage_bill: ", show(wage_bill)];