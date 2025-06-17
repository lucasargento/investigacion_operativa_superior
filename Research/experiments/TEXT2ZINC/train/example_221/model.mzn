% Parameters
int: X0; % Initial position
int: V0; % Initial velocity
int: XT; % Final position
int: VT; % Final velocity
int: T;  % Duration

% Decision Variables
array[0..T] of var int: x; % Position at each time step
array[0..T] of var int: v; % Velocity at each time step
array[0..T] of var int: a; % Acceleration (thrust) at each time step

% Objective
var int: max_thrust; % Maximum thrust required
constraint max_thrust = max([abs(a[t]) | t in 0..T]);
solve minimize max_thrust;

% Constraints
% Initial conditions
constraint x[0] = X0;
constraint v[0] = V0;

% Final conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Discrete-time model
constraint forall(t in 0..T-1) (
    x[t+1] = x[t] + v[t],
    v[t+1] = v[t] + a[t]
);