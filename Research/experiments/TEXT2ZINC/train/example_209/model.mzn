% Parameters
int: capacity; % Capacity of each floppy disk
array[1..N] of int: size; % Size of each file

% Decision Variables
var 1..N: n_disks; % Total number of floppy disks used
array[1..N] of var 1..N: whichdisk; % On which disk each file is distributed

% Constraints
constraint forall(i in 1..N)(sum(j in 1..N)(if whichdisk[j] = i then size[j] else 0 endif) <= capacity);
constraint forall(i in 1..N-1)(sum(j in 1..N)(if whichdisk[j] = i then 1 else 0 endif) >= sum(j in 1..N)(if whichdisk[j] = i+1 then 1 else 0 endif));

% Objective
solve minimize n_disks;

% Output
output ["n_disks: ", show(n_disks), "\n", "whichdisk: ", show(whichdisk)];