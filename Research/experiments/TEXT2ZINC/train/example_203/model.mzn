% Parameters
int: NumShifts; % Number of shifts
array[1..NumShifts] of int: OfficersNeeded; % Officers needed for each shift
array[1..NumShifts] of int: ShiftCosts; % Cost of assigning an officer to each shift

% Decision Variables
array[1..NumShifts] of var 0..max(OfficersNeeded): OfficersAssigned; % Officers assigned to each shift

% Objective
var int: TotalCost; % Total cost for the town

% Constraints
constraint forall(i in 1..NumShifts) (
    OfficersAssigned[i] + OfficersAssigned[i mod NumShifts + 1] >= OfficersNeeded[i]
);

constraint TotalCost = sum(i in 1..NumShifts) (OfficersAssigned[i] * ShiftCosts[i]);

% Objective Function
solve minimize TotalCost;

% Output
output ["{\"officers_assigned\": [", join(", ", [show(OfficersAssigned[i]) | i in 1..NumShifts]), "], \"total_cost\": ", show(TotalCost), "}"];