var int: hours_factory1;
% number of hours facroty 2 is run
var int: hours_factory2;

% number of hours must be non-negative
constraint hours_factory1 >= 0;
constraint hours_factory2 >= 0;

% The pharmacy has available 5000 units of base gel. 
% factory 1 requires 30 units of base gel per hour while factory 2 requires 45 units of base gel per hour
constraint hours_factory1 * 30 + hours_factory2 * 45 <= 5000;

% they must make at least 800 units of acne cream a
% factory 1 produces 12 units of acne cream and Factory 2 produces 20 units of acne cream
constraint hours_factory1 * 12 + hours_factory2 * 20 >= 800;

% they must make at least 1000 units of anti - bacterial cream 
% factory 1 produces 15 units of anti-bacterial cream per hour and factory 2 produces 10 units of anti-bacterial cream per hour
constraint hours_factory1 * 15 + hours_factory2 * 10 >= 1000;

% minimize the total time needed 
solve minimize hours_factory1 + hours_factory2;

% output
output ["Hours for Factory 1: " ++ show(hours_factory1) ++ "\nHours for Factory 2: " ++ show(hours_factory2)];