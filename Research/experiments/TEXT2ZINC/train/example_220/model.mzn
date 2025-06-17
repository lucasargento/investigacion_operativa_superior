% Parameters
int: P; % Number of products
int: Cash; % Initial cash available
array[1..P] of int: Hour; % Hours required to produce each product
array[1..P] of int: Cost; % Cost to produce each product
array[1..P] of int: Price; % Price at which each product can be sold
array[1..P] of float: InvestPercentage; % Percentage of income from each product to be reinvested
int: UpgradeHours; % Hours required for upgrading the machinery
int: UpgradeCost; % Cost associated with upgrading
int: AvailableHours; % Total available hours for machine operation

% Decision Variables
var 0..Cash: net_income; % Net income of the company
array[1..P] of var 0..Cash: production; % Production quantity of each product
var bool: upgrade; % Whether the company should upgrade its machine capacity or not

% Constraints
constraint forall(i in 1..P) (
    production[i] * Hour[i] <= AvailableHours + (upgrade * UpgradeHours) % Machine capacity constraint
    /\ production[i] * Cost[i] <= Cash - (upgrade * UpgradeCost) % Cash availability constraint
);

constraint forall(i in 1..P) (
    net_income >= (production[i] * Price[i]) - (production[i] * Cost[i]) - (production[i] * Price[i] * InvestPercentage[i]) % Net income calculation
);

% Objective
solve maximize net_income;

% Output
output ["net_income: ", show(net_income), "\n", "production: ", show(production), "\n", "upgrade: ", show(upgrade)];