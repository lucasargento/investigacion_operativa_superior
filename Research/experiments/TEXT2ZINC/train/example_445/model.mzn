% Parameters
int: NumProducts; % Number of products
int: NumStages; % Number of stages
array[1..NumProducts, 1..NumStages] of int: ProductionRate; % Production rate for each product in each stage
array[1..NumProducts] of int: ProfitPerTon; % Profit per ton for each product
array[1..NumProducts] of int: MinCommitment; % Minimum commitment for each product
array[1..NumProducts] of int: MaxMarketLimit; % Maximum market limit for each product
array[1..NumStages] of int: StageAvailability; % Stage availability for each stage

% Decision Variables
array[1..NumProducts] of var MinCommitment[1..NumProducts]..MaxMarketLimit[1..NumProducts]: TonsProduced; % Tons to be produced for each product

% Objective
maximize sum(p in 1..NumProducts)(ProfitPerTon[p] * TonsProduced[p]);

% Constraints
constraint forall(s in 1..NumStages)(
    sum(p in 1..NumProducts)(TonsProduced[p] / ProductionRate[p,s]) <= StageAvailability[s]
);