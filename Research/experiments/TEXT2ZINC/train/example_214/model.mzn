% Parameters
int: NumParts; % Number of parts
int: NumMachines; % Number of machines
array[1..NumParts, 1..NumMachines] of int: Time; % Time required for each part on each machine
array[1..NumParts] of int: Profit; % Profit for each part
array[1..NumMachines] of int: Capacity; % Capacity of each machine

% Decision Variables
array[1..NumParts] of var 0..Capacity[1]: quantity; % Quantity of each part to be made

% Objective
maximize sum(k in 1..NumParts)(Profit[k]*quantity[k]);

% Constraints
constraint forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(Time[k,s]*quantity[k]) <= Capacity[s]
);