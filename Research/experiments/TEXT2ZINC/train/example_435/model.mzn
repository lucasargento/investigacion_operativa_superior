% Parameters
int: AlloysOnMarket;
int: RequiredElements;
array[1..RequiredElements, 1..AlloysOnMarket] of float: CompositionDataPercentage;
array[1..RequiredElements] of float: DesiredBlendPercentage;
array[1..AlloysOnMarket] of int: AlloyPrice;

% Decision Variables
array[1..AlloysOnMarket] of var 0..100: AlloyQuantity;

% Constraints
constraint forall(e in 1..RequiredElements)(
    sum(a in 1..AlloysOnMarket)(CompositionDataPercentage[e,a]*AlloyQuantity[a]) = DesiredBlendPercentage[e]*sum(a in 1..AlloysOnMarket)(AlloyQuantity[a])
);

% Objective
var int: TotalCost = sum(a in 1..AlloysOnMarket)(AlloyPrice[a]*AlloyQuantity[a]);
solve minimize TotalCost;

% Output
output ["AlloyQuantity: ", show(AlloyQuantity), "\n", "TotalCost: ", show(TotalCost)];