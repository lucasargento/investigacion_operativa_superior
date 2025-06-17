% MiniZinc model for the cutting stock problem

% Parameters
int: NumWidths; % Number of widths
array[1..NumWidths] of int: Widths; % Widths to be cut
int: RollWidth; % Width of the roll
array[1..NumWidths] of int: Orders; % Number of orders for each width
int: NumPatterns; % Number of patterns
array[1..NumWidths, 1..NumPatterns] of int: NumRollsWidthPattern; % Number of rolls of each width for each pattern

% Variables
array[1..NumPatterns] of var 0..sum(Orders): NumRollsPattern; % Number of rolls cut using each pattern

% Objective: Minimize the total number of raw rolls cut
minimize sum(NumRollsPattern);

% Constraints
constraint forall(i in 1..NumWidths) (
  sum(j in 1..NumPatterns) (NumRollsWidthPattern[i,j] * NumRollsPattern[j]) >= Orders[i]
);