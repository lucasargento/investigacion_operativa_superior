var int: new_grads;
% number of senior engineers
var int: senior;

% number of engineers is non-negative
constraint new_grads >= 0;
constraint senior >= 0;

% there are at least 50 engineers
constraint new_grads + senior >= 50;
% there are at least 10 senior engineers
constraint senior >= 10;
% senior engineers should be at least a third the number of new grad engineers
constraint senior >= new_grads / 3;

% new grad engineers earn 1000 a week and senior engineers earn 3000 a week
var int: wage_bill = 1000*new_grads + 3000*senior;

% weekly wage bill must be kept below $ 100000 
constraint wage_bill <= 100000;

% minimize the wage_bill
solve minimize wage_bill;