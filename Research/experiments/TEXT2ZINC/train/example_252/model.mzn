% Define parameters
int: N;
array[1..N] of bool: IsWorkstation;
array[1..N] of int: Price;
array[1..N] of float: DiskDrives;
array[1..N] of int: MemoryBoards;
array[1..N] of int: Demand;
array[1..N] of int: Preorder;
array[1..N] of bool: AltCompatible;
int: MaxCpu;
int: MinDisk;
int: MaxDisk;
int: MinMemory;
int: MaxMemory;
int: DemandGP;
int: DemandWS;
int: AltMemory;

% Define decision variables
array[1..N] of var 0..Demand[i]: NumProduced;
array[1..N] of var 0..MemoryBoards[i]*NumProduced[i]: Total256KBoardsUsed;
array[1..N] of var 0..AltMemory: TotalAltBoardsUsed;
array[1..N] of var 0..DiskDrives[i]*NumProduced[i]: TotalDiskDrivesUsed;

% Define constraints
constraint sum(i in 1..N)(NumProduced[i]) <= MaxCpu;
constraint sum(i in 1..N)(TotalDiskDrivesUsed[i]) >= MinDisk;
constraint sum(i in 1..N)(TotalDiskDrivesUsed[i]) <= MaxDisk;
constraint sum(i in 1..N)(Total256KBoardsUsed[i] + TotalAltBoardsUsed[i]) >= MinMemory;
constraint sum(i in 1..N)(Total256KBoardsUsed[i] + TotalAltBoardsUsed[i]) <= MaxMemory;
constraint sum(i in 1..N where IsWorkstation[i])(NumProduced[i]) <= DemandWS;
constraint sum(i in 1..N where not IsWorkstation[i])(NumProduced[i]) <= DemandGP;
constraint forall(i in 1..N)(NumProduced[i] >= Preorder[i]);
constraint forall(i in 1..N)(TotalAltBoardsUsed[i] <= AltMemory * AltCompatible[i]);

% Define objective function
var int: Profit = sum(i in 1..N)(Price[i] * NumProduced[i]);

% Maximize profit
solve maximize Profit;

% Output
output ["{\"system_output\": ["] ++
        [ "{ \"num_produced\": " ++ show(NumProduced[i]) ++ 
          ", \"total_256K_boards_used\": " ++ show(Total256KBoardsUsed[i]) ++ 
          ", \"total_alt_boards_used\": " ++ show(TotalAltBoardsUsed[i]) ++ 
          ", \"total_disk_drives_used\": " ++ show(TotalDiskDrivesUsed[i]) ++ "}" | i in 1..N] ++
        ["], \"profit\": " ++ show(Profit) ++ "}"];