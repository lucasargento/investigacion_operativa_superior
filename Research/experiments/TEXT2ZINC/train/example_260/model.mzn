% Define parameters
int: N; % Number of products
array[1..N] of float: AssemblyHour; % Assembly hours required for each product
array[1..N] of float: TestingHour; % Testing hours required for each product
array[1..N] of float: MaterialCost; % Material cost for each product
float: MaxAssembly; % Maximum assembly hours
float: MaxTesting; % Maximum testing hours
array[1..N] of float: Price; % Price of each product
float: MaxOvertimeAssembly; % Maximum overtime assembly hours
float: OvertimeAssemblyCost; % Overtime assembly cost per hour
float: MaterialDiscount; % Material discount percentage
float: DiscountThreshold; % Discount threshold

% Define decision variables
array[1..N] of var 0..100: UnitsProduced; % Number of units produced for each product
var 0..MaxOvertimeAssembly: OvertimeAssembly; % Overtime assembly hours
var 0..1000: MaterialBought; % Amount of raw materials bought

% Define objective function
var float: DailyProfit; % Daily profit

% Define constraints
constraint sum(i in 1..N)(AssemblyHour[i]*UnitsProduced[i]) <= MaxAssembly + OvertimeAssembly;
constraint sum(i in 1..N)(TestingHour[i]*UnitsProduced[i]) <= MaxTesting;
constraint sum(i in 1..N)(MaterialCost[i]*UnitsProduced[i]) = MaterialBought;
constraint if MaterialBought >= DiscountThreshold then MaterialBought = MaterialBought * (1 - MaterialDiscount/100) else true endif;
constraint DailyProfit = sum(i in 1..N)(Price[i]*UnitsProduced[i]) - MaterialBought - OvertimeAssembly*OvertimeAssemblyCost;

% Define objective
solve maximize DailyProfit;

% Output
output ["dailyProfit: ", show(DailyProfit), "\n",
        "unitsProduced: ", show(UnitsProduced), "\n",
        "overtimeAssembly: ", show(OvertimeAssembly), "\n",
        "materialBought: ", show(MaterialBought), "\n"];