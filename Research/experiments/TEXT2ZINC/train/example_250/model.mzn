% Parameters
int: translators; % Number of translators
array[1..translators] of int: translator_costs; % Cost of each translator
array[1..translators, 1..8] of 0..1: translator_languages; % Languages each translator can translate
array[1..8] of 0..1: required_languages; % Required languages

% Decision Variables
array[1..translators] of var 0..1: selected_translators; % Whether each translator is selected or not

% Objective
var int: total_cost = sum(i in 1..translators) (selected_translators[i] * translator_costs[i]);
minimize total_cost;

% Constraints
constraint forall(j in 1..8) (
    sum(i in 1..translators) (selected_translators[i] * translator_languages[i,j]) >= required_languages[j]
);

% Output
solve satisfy;
output ["selected_translators: ", show(selected_translators), "\n", "total_cost: ", show(total_cost)];