% Define parameters
int: NumMachines;
int: NumParts;
array[1..NumMachines, 1..NumParts] of int: TimeRequired;
array[1..NumMachines] of int: MachineCosts;
array[1..NumMachines] of int: Availability;
array[1..NumParts] of int: Prices;
array[1..NumParts] of int: MinBatches;
int: StandardCost;
int: OvertimeCost;
array[1..NumMachines] of int: OvertimeHour;

% Define decision variables
array[1..NumParts] of var 0..1000: Batches; % Number of batches for each part
array[1..NumMachines] of var 0..1000: MachineHours; % Number of hours for each machine

% Define constraints
constraint forall(m in 2..NumMachines) (
    sum(p in 1..NumParts) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

constraint forall(p in 1..NumParts) (
    Batches[p] >= MinBatches[p]
);

constraint MachineHours[1] = sum(p in 1..NumParts) (TimeRequired[1,p] * Batches[p]);

constraint MachineHours[1] <= OvertimeHour[1];

% Define objective function
var int: TotalProfit = sum(p in 1..NumParts) (Prices[p] * Batches[p]) - 
                        sum(m in 1..NumMachines) (MachineCosts[m] * MachineHours[m]) - 
                        StandardCost * min(MachineHours[1], OvertimeHour[1]) - 
                        OvertimeCost * max(0, MachineHours[1] - OvertimeHour[1]);

% Maximize total profit
solve maximize TotalProfit;

% Output
output ["Batches: ", show(Batches), "\n", "TotalProfit: ", show(TotalProfit)];