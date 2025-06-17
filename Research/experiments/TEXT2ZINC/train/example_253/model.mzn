% Define parameters
int: I; % Number of depots
int: J; % Number of ports
array[1..I] of int: numdepot; % Number of containers in each depot
array[1..J] of int: numport; % Number of containers required in each port
float: price; % Price per unit distance
array[1..I, 1..J] of float: distance; % Distance between each depot and port

% Define decision variables
array[1..I, 1..J] of var 0..max(numdepot) div 2: number; % Number of containers sent from each depot to port

% Define constraints
constraint forall(i in 1..I)(sum(j in 1..J)(number[i,j]) <= numdepot[i] div 2); % Cannot send more containers than available in depot
constraint forall(j in 1..J)(sum(i in 1..I)(number[i,j]) >= numport[j] div 2); % Must meet the container requirement in each port

% Define objective function
var float: total_cost = sum(i in 1..I, j in 1..J)(number[i,j] * distance[i,j] * price);

% Minimize total cost
solve minimize total_cost;

% Output solution
output ["number: ", show2dArray([ [number[i,j] | j in 1..J] | i in 1..I])];