% Parameters
int: all_space;
int: n_heifers;
int: n_milk;
float: heifer_space;
float: cow_space;
float: cow_calve;
int: price_bullock;
int: price_heifer;
int: price_cow;
float: loss_heifer;
float: loss_cow;
int: revenue_milk;
int: n_maxcow;
int: cow_outlay;
float: cow_grain;
float: cow_sugar;
float: sugar_per_acre;
int: space_grain;
array[1..4] of int: graindivision;
array[1..4] of float: yield;
int: buyprice_grain;
int: sellprice_grain;
int: buyprice_sugar;
int: sellprice_sugar;
int: labour_heifers;
int: labour_cow;
int: labour_grain;
int: labour_sugar;
int: extra_heifers;
int: extra_cow;
int: extra_grain;
int: extra_sugar;
int: labour_cost;
int: labour_hour;
float: extra_labour_cost;

% Decision Variables
var 0..n_heifers: sellheifer;
array[1..5] of var 0..space_grain: spacegrain;
array[1..5] of var 0..(all_space-space_grain): spacesugar;

% Constraints
constraint forall(i in 1..5)(spacegrain[i] + spacesugar[i] <= all_space);
constraint forall(i in 1..5)(labour_heifers*n_heifers + labour_cow*n_milk + labour_grain*spacegrain[i] + labour_sugar*spacesugar[i] <= labour_hour + extra_labour_cost*(labour_cost - labour_hour));

% Objective Function
var int: profit = sum(i in 1..5)(revenue_milk*n_milk - extra_cow*n_milk - cow_grain*buyprice_grain*n_milk - cow_sugar*buyprice_sugar*n_milk + sellprice_grain*sum(j in 1..4)(yield[j]*graindivision[j]) - extra_grain*spacegrain[i] + sellprice_sugar*sugar_per_acre*spacesugar[i] - extra_sugar*spacesugar[i] + price_bullock*cow_calve*n_milk/2 + price_heifer*sellheifer + price_cow*n_milk*loss_cow - extra_heifers*n_heifers);
solve maximize profit;

% Output
output ["sellheifer: \(sellheifer)\n"] ++ ["spacegrain: \(spacegrain[i])\n" | i in 1..5] ++ ["spacesugar: \(spacesugar[i])\n" | i in 1..5];