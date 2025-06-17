% Parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix;

% Decision Variables
% AssignMatrix[p,c] is 1 if participant p is assigned to car c, 0 otherwise
array[1..ParticipantNum, 1..CarNum] of var 0..1: AssignMatrix;

% Objective
% Maximize the total number of assignments
var int: total_assignments = sum(p in 1..ParticipantNum, c in 1..CarNum) (AssignMatrix[p,c]);
maximize total_assignments;

% Constraints
% Each participant can be assigned to at most one car
constraint forall(p in 1..ParticipantNum) (sum(c in 1..CarNum) (AssignMatrix[p,c]) <= 1);

% Each car can be assigned to at most one participant
constraint forall(c in 1..CarNum) (sum(p in 1..ParticipantNum) (AssignMatrix[p,c]) <= 1);

% A participant can only be assigned to a car if they are interested in it
constraint forall(p in 1..ParticipantNum, c in 1..CarNum) (AssignMatrix[p,c] <= InterestMatrix[p,c]);

% A car can only be assigned to a participant if they are interested in it
constraint forall(p in 1..ParticipantNum, c in 1..CarNum) (AssignMatrix[p,c] >= InterestMatrix[p,c]);

% Solve
solve satisfy;