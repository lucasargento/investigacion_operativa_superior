% Define parameters
int: NumLinks; % Number of links
array[1..NumLinks] of int: StartNode; % Start node of each link
array[1..NumLinks] of int: EndNode; % End node of each link
array[1..NumLinks] of int: Capacity; % Capacity of each link
array[1..NumLinks] of int: Cost; % Cost of each link
int: NumFlowReqs; % Number of flow requirements
array[1..NumFlowReqs] of int: Source; % Source node of each flow requirement
array[1..NumFlowReqs] of int: Destination; % Destination node of each flow requirement
array[1..NumFlowReqs] of int: DataRate; % Data rate of each flow requirement

% Define decision variables
array[1..NumLinks, 1..NumFlowReqs] of var 0..Capacity: Flow; % Flow on each link for each flow requirement

% Define objective function
var int: TotalCost = sum(i in 1..NumLinks, j in 1..NumFlowReqs) (Flow[i,j] * Cost[i]);

% Define constraints
constraint forall(j in 1..NumFlowReqs) (
    sum(i in 1..NumLinks) (Flow[i,j]) >= DataRate[j] % Flow requirement constraint
);

constraint forall(i in 1..NumLinks) (
    sum(j in 1..NumFlowReqs) (Flow[i,j]) <= Capacity[i] % Capacity constraint
);

% Solve the problem
solve minimize TotalCost;

% Output the solution
output ["TotalCost: ", show(TotalCost), "\n"] ++
["Flow: ", show(Flow), "\n"];