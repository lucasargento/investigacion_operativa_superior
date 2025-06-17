% Employee Assignment Problem
% Goal: Assign employees to shifts in different restaurants based on skills and preferences

% Input parameters
int: NumRestaurants;     % Number of restaurants
int: NumEmployees;       % Number of employees
int: NumShifts;          % Number of shifts per day
int: NumSkills;          % Number of possible skills

% 3D array: Demand[restaurant, shift, skill]
array[1..NumRestaurants, 1..NumShifts, 1..NumSkills] of int: Demand;

% 2D array: EmployeeSkills[employee, skill] - 1 if employee has the skill, 0 otherwise
array[1..NumEmployees, 1..NumSkills] of int: EmployeeSkills;

% 2D array: SkillPreference[employee, skill] - preference level of employee for each skill
array[1..NumEmployees, 1..NumSkills] of int: SkillPreference;

% 2D array: ShiftAvailability[employee, shift] - 1 if employee is available for the shift, 0 otherwise
array[1..NumEmployees, 1..NumShifts] of int: ShiftAvailability;

% Cost weight for unfulfilled positions
int: UnfulfilledPositionWeight;

% Decision variable: Assignment[restaurant, shift, skill, employee] - 1 if employee is assigned, 0 otherwise
array[1..NumRestaurants, 1..NumShifts, 1..NumSkills, 1..NumEmployees] of var 0..1: Assignment;

% Constraint: Each demand for a skill in a restaurant shift should be met by assigned employees
constraint
    forall(r in 1..NumRestaurants, s in 1..NumShifts, k in 1..NumSkills) (
        sum(e in 1..NumEmployees) (
            Assignment[r, s, k, e] * EmployeeSkills[e, k] * ShiftAvailability[e, s]
        ) >= Demand[r, s, k]
    );

% Objective: Minimize the cost of unfulfilled positions and less preferred assignments
var int: total_cost;

% Cost of unfulfilled positions
var int: unfulfilled_cost = sum(r in 1..NumRestaurants, s in 1..NumShifts, k in 1..NumSkills) (
    let {
        var int: fulfilled_positions = sum(e in 1..NumEmployees) (
            Assignment[r, s, k, e] * EmployeeSkills[e, k] * ShiftAvailability[e, s]
        )
    } in max(0, Demand[r, s, k] - fulfilled_positions) * UnfulfilledPositionWeight
);

% Cost of assigning employees to less preferred positions
var int: preference_cost = sum(r in 1..NumRestaurants, s in 1..NumShifts, k in 1..NumSkills, e in 1..NumEmployees) (
    Assignment[r, s, k, e] * (10 - SkillPreference[e, k])
);

% Total cost
constraint total_cost = unfulfilled_cost + preference_cost;

% Minimize the total cost
solve minimize total_cost;

% Output the assignment schedule
output [
    "Assignment Schedule:\n" ++
    concat([
        "Restaurant ", show(r), ", Shift ", show(s), ", Skill ", show(k), ": " ++
        concat([ if Assignment[r, s, k, e] = 1 then "Employee " ++ show(e) ++ " " else "" endif | e in 1..NumEmployees ]) ++ "\n"
        | r in 1..NumRestaurants, s in 1..NumShifts, k in 1..NumSkills
    ])
];