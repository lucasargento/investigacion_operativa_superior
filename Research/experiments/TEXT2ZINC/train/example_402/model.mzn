var int: lab1_hours;
% hours lab 2 is run for
var int: lab2_hours;

% hours run is non-negative
constraint lab1_hours >= 0;
constraint lab2_hours >= 0;

% The company has 1500 worker hours available
% each session at lab 1 requires 3 hours of workers labor and each session at lab 2 requires 5 hours of worker labor
constraint lab1_hours * 3 + lab2_hours * 5 <= 1500;

% the company must make at least 20000 heart medication pills
% lab 1 can produce 20 heart medication pills per hour and lab 2 can produce 30 heart medication pills per hour
constraint lab1_hours * 20 + lab2_hours * 30 >= 20000;

% the company must make at least 30000 lung medication pills
% lab 1 can produce 30 lung medication pills per hour and lab 2 can produce 40 lung medication pills per hour
constraint lab1_hours * 30 + lab2_hours * 40 >= 30000;

% minimize the total time needed 
solve minimize lab1_hours + lab2_hours;

% Output
output ["Lab 1 hours: " ++ show(lab1_hours) ++ "\n" ++ "Lab 2 hours: " ++ show(lab2_hours)];