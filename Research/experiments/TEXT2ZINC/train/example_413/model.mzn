var int: gummy; 
% number of units of powder
var int: powder;

% units are non-negative
constraint gummy >= 0;
constraint powder >= 0;

% man needs at least 14 units of vitamin B. 
% vitamin B from gummy bears is 2 units each and from powder is 6 units each
constraint 2*gummy + 6*powder >= 14;

% man needs at least 24 units of vitamin D. 
%vitamin D from gummy bears is 7 units each and from powder is 2 units each
constraint 7*gummy + 2*powder >= 24;

% cost of gummy is $1 each and powder is $3 each
var int: cost = gummy + 3*powder;

% minimize cost
solve minimize cost; 

output ["Gummy: " ++ show(gummy) ++ "\nPowder: " ++ show(powder)];