var int: children_vaccines; 
% number of adult vaccines
var int: adult_vaccines; 

% vaccines produced are non-negative
constraint children_vaccines >= 0;
constraint adult_vaccines >= 0;

% 20000 mg of mRNA anti-viral is available
% children's vaccines contains 50mg of mRNA and adult vaccine contains 75mg of mRNA
constraint children_vaccines * 50 + adult_vaccines * 75 <= 20000; 
% at least 70% of vaccines should be adult vacines
constraint adult_vaccines >= 0.7 * (children_vaccines + adult_vaccines); 
% at least 50 children's vaccines should be made
constraint children_vaccines >= 50;

% each children 's vaccine contains 50 mg of fever suppressant and each adult vaccine contains 75 mg of fever suppressant
var int: total_fever_suppressant = children_vaccines * 50 + adult_vaccines * 75;

% minimize the amount of fever suppressant used
solve minimize total_fever_suppressant;

% output
output ["Children's Vaccines: " ++ show(children_vaccines) ++ "\nAdult Vaccines: " ++ show(adult_vaccines)];