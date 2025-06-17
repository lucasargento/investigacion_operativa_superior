% Parameters
int: FoodNum;
int: NutrientNum;
array[1..FoodNum] of int: CostPerFood;
array[1..FoodNum] of int: FoodMin;
array[1..FoodNum] of int: FoodMax;
array[1..NutrientNum] of int: MinReqAmount;
array[1..NutrientNum] of int: MaxReqAmount;
array[1..FoodNum, 1..NutrientNum] of int: AmountPerNutrient;

% Decision Variables
array[1..FoodNum] of var FoodMin[1]..FoodMax[1]: FoodAmount;

% Objective
var int: TotalCost = sum(j in 1..FoodNum)(CostPerFood[j]*FoodAmount[j]);
minimize TotalCost;

% Constraints
constraint forall(i in 1..NutrientNum)(
    sum(j in 1..FoodNum)(AmountPerNutrient[j,i]*FoodAmount[j]) >= MinReqAmount[i] /\
    sum(j in 1..FoodNum)(AmountPerNutrient[j,i]*FoodAmount[j]) <= MaxReqAmount[i]
);

solve satisfy;
output [ "FoodAmount: \(FoodAmount)\nTotalCost: \(TotalCost)\n" ];