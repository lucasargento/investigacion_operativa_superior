% Parameters
int: NumProducts; % Number of products
int: NumMachines; % Number of machines or stations
array[1..NumProducts, 1..NumMachines] of int: ProduceTime; % Time to produce each product on each machine
array[1..NumMachines] of int: AvailableTime; % Total available time for each machine
array[1..NumProducts] of int: Profit; % Profit from producing one unit of each product

% Decision Variables
array[1..NumProducts] of var 0..max(AvailableTime): quantity; % Quantity to produce for each product

% Objective
maximize sum(k in 1..NumProducts)(Profit[k]*quantity[k]);

% Constraints
constraint forall(s in 1..NumMachines)(
    sum(k in 1..NumProducts)(ProduceTime[k,s]*quantity[k]) <= AvailableTime[s]
);