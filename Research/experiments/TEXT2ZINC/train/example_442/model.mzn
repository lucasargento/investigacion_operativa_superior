% Parameters
int: ElementNum;
array[1..ElementNum] of int: CoefficientA;
array[1..ElementNum] of int: ProfitCoefficientC;
array[1..ElementNum] of int: UpperBoundU;
int: GlobalParameterB;

% Decision Variables
array[1..ElementNum] of var 0..max(UpperBoundU): DecisionVariableX;

% Objective
maximize sum(j in 1..ElementNum) (ProfitCoefficientC[j] * DecisionVariableX[j]);

% Constraints
constraint sum(j in 1..ElementNum) ((1.0/CoefficientA[j]) * DecisionVariableX[j]) <= GlobalParameterB;
constraint forall(j in 1..ElementNum) (DecisionVariableX[j] >= 0 /\ DecisionVariableX[j] <= UpperBoundU[j]);