% Number of customers and vehicles
int: num_customers;
int: num_vehicles;

% Customer demands, time windows, distances and service times
array[1..num_customers] of int: customer_demand;
array[1..num_customers] of int: customer_LBTW;
array[1..num_customers] of int: customer_UBTW;
array[1..num_customers, 1..num_customers] of int: customer_distance;
array[1..num_customers] of int: customer_service_time;

% Vehicle capacities
array[1..num_vehicles] of int: vehicle_capacity;

% Decision variables
array[1..num_vehicles, 1..num_customers] of var 0..1: x; % x[i,j] = 1 if vehicle i serves customer j
array[1..num_vehicles, 1..num_customers] of var int: arrival_time; % arrival time of vehicle i at customer j

% Objective: Minimize the total distance travelled by all vehicles
var int: total_distance = sum(i in 1..num_vehicles, j in 1..num_customers, k in 1..num_customers) (x[i,j]*x[i,k]*customer_distance[j,k]);
minimize total_distance;

% Constraints
% Each customer is served by exactly one vehicle
constraint forall(j in 1..num_customers) (sum(i in 1..num_vehicles) (x[i,j]) = 1);

% The total demand served by each vehicle does not exceed its capacity
constraint forall(i in 1..num_vehicles) (sum(j in 1..num_customers) (x[i,j]*customer_demand[j]) <= vehicle_capacity[i]);

% The arrival time at each customer is within the customer's time window
constraint forall(i in 1..num_vehicles, j in 1..num_customers) (arrival_time[i,j] >= customer_LBTW[j]*x[i,j] /\ arrival_time[i,j] <= customer_UBTW[j]*x[i,j]);

% The arrival time at each customer is after the departure time from the previous customer
constraint forall(i in 1..num_vehicles, j in 1..num_customers, k in 1..num_customers) (arrival_time[i,j] >= arrival_time[i,k] + customer_service_time[k]*x[i,k] + customer_distance[k,j]*x[i,j]*x[i,k]);

% The arrival time at each customer is before the departure time to the next customer
constraint forall(i in 1..num_vehicles, j in 1..num_customers, k in 1..num_customers) (arrival_time[i,j] + customer_service_time[j]*x[i,j] + customer_distance[j,k]*x[i,j]*x[i,k] <= arrival_time[i,k]);

solve satisfy;