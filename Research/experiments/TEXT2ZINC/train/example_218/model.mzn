% Parameters
int: InitialPosition; % Initial position of the rocket
int: InitialVelocity; % Initial velocity of the rocket
int: FinalPosition; % Final position of the rocket
int: FinalVelocity; % Final velocity of the rocket
int: TotalTime; % Total time for the rocket to reach the final position

% Decision Variables
array[0..TotalTime] of var int: x; % Position of the rocket at each time step
array[0..TotalTime] of var int: v; % Velocity of the rocket at each time step
array[0..TotalTime-1] of var int: a; % Acceleration of the rocket at each time step

% Objective Function
var int: fuel_spend = sum(t in 0..TotalTime-1)(abs(a[t])); % Total fuel spent
minimize fuel_spend;

% Constraints
% Initial conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% Final conditions
constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Dynamics of the rocket
constraint forall(t in 0..TotalTime-1)(
    x[t+1] = x[t] + v[t] /\ v[t+1] = v[t] + a[t]
);