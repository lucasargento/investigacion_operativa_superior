include "globals.mzn";

% Number of employees
int: n = 6;

% Office assignments (1-6)
array[1..n] of var 1..6: offices;

% Employees
enum EMPLOYEE = {Arthur, Bella, Craig, Duncan, Elizabeth, Francesca};

% Define the office positions for clarity
var 1..6: Arthur_office = offices[1];
var 1..6: Bella_office = offices[2];
var 1..6: Craig_office = offices[3];
var 1..6: Duncan_office = offices[4];
var 1..6: Elizabeth_office = offices[5];
var 1..6: Francesca_office = offices[6];

% Constraints
% Arthur is directly above Bella
constraint Arthur_office == Bella_office + 3;

% Bella works next to Duncan
constraint abs(Bella_office - Duncan_office) == 1;

% % Elizabeth’s office number is smaller than Francesca’s
constraint Elizabeth_office < Francesca_office;

% Craig and Francesca are in adjacent rooms
constraint abs(Craig_office - Francesca_office) == 1;

% ensure all offices are unique
constraint alldifferent(offices);

% satisfaction
solve satisfy;

% output
output ["Arthur: ", show(Arthur_office), "\n",
        "Bella: ", show(Bella_office), "\n",
        "Craig: ", show(Craig_office), "\n",
        "Duncan: ", show(Duncan_office), "\n",
        "Elizabeth: ", show(Elizabeth_office), "\n",
        "Francesca: ", show(Francesca_office), "\n"];