% Parameters
int: NutrientCount;
int: FoodCount;
array[1..FoodCount] of int: Cost;
array[1..FoodCount] of int: FoodMin;
array[1..FoodCount] of int: FoodMax;
array[1..NutrientCount] of int: NutrientMin;
array[1..NutrientCount] of int: NutrientMax;
array[1..NutrientCount, 1..FoodCount] of int: AmountNutrient;

% Decision Variables
array[1..FoodCount] of var FoodMin[1]..FoodMax[1]: FoodAmount;

% Objective
var int: TotalCost = sum(j in 1..FoodCount)(Cost[j]*FoodAmount[j]);
minimize TotalCost;

% Constraints
constraint forall(i in 1..NutrientCount)(
    sum(j in 1..FoodCount)(AmountNutrient[i,j]*FoodAmount[j]) >= NutrientMin[i] /\
    sum(j in 1..FoodCount)(AmountNutrient[i,j]*FoodAmount[j]) <= NutrientMax[i]
);

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Food amounts: "] ++ [show(FoodAmount[j]) | j in 1..FoodCount];