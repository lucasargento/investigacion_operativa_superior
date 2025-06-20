% Parameters
int: TotalAircrafts;
array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

% Decision Variables
array[1..TotalAircrafts] of var EarliestLandingTime[i]..LatestLandingTime[i]: LandingTime;

% Constraints
constraint forall(i in 1..TotalAircrafts, j in i+1..TotalAircrafts) (
    LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i,j]
);

% Objective Function
var int: TotalPenalty = sum(i in 1..TotalAircrafts) (
    if LandingTime[i] > TargetLandingTime[i] then
        (LandingTime[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i]
    elseif LandingTime[i] < TargetLandingTime[i] then
        (TargetLandingTime[i] - LandingTime[i]) * PenaltyTimeBeforeTarget[i]
    else
        0
    endif
);

% Solve
solve minimize TotalPenalty;

% Output
output [ "LandingTime for Aircraft " ++ show(i) ++ ": " ++ show(LandingTime[i]) ++ "\n" | i in 1..TotalAircrafts ];