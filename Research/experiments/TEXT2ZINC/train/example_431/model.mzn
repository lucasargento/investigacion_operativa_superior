% Parameters
int: JobCount; % Number of jobs
int: MachineCount; % Number of machines
array[1..JobCount, 1..MachineCount] of int: ProcessingTime; % Processing time for each job on each machine

% Decision Variables
array[1..JobCount] of var 1..JobCount: JobSequence; % Sequence of jobs
array[1..JobCount, 1..MachineCount] of var 0..sum(ProcessingTime) : StartTime; % Start time for each job on each machine

% Constraints
% Each job must be processed once
constraint alldifferent(JobSequence);

% The start time of the first job on the first machine is 0
constraint StartTime[1,1] = 0;

% The start time of each job on the first machine is the end time of the previous job on the first machine
constraint forall(j in 2..JobCount) (
    StartTime[j,1] = StartTime[j-1,1] + ProcessingTime[JobSequence[j-1],1]
);

% The start time of each job on each machine (except the first) is the maximum of the end time of the previous job on the same machine and the end time of the same job on the previous machine
constraint forall(j in 1..JobCount, m in 2..MachineCount) (
    StartTime[j,m] >= StartTime[j,m-1] + ProcessingTime[JobSequence[j],m-1]
);
constraint forall(j in 2..JobCount, m in 2..MachineCount) (
    StartTime[j,m] >= StartTime[j-1,m] + ProcessingTime[JobSequence[j-1],m]
);

% Objective
% Minimize the makespan, which is the end time of the last job on the last machine
var int: Makespan = StartTime[JobCount,MachineCount] + ProcessingTime[JobSequence[JobCount],MachineCount];
solve minimize Makespan;

% Output
output ["Job Sequence: ", show(JobSequence), "\nMakespan: ", show(Makespan)];