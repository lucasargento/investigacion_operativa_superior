int: num_items = 22;
array[1..num_items, 1..2] of int: items;
array[1..num_items] of string: items_str;

% decision variables
array[1..num_items] of var 0..1: x;
var int: total_weight = sum(i in 1..num_items) ( x[i]*items[i,1] );
var int: total_value  = sum(i in 1..num_items) ( x[i]*items[i,2] );

solve :: int_search(
        x, 
        input_order, 
        indomain_max, 
        complete) 
    maximize total_value;
    % satisfy;


constraint
    total_weight <= 400 

    % /\ total_value = 1030 % testing all optimal solutions
;

output 
[
  "total_value: " ++ show(total_value) ++ "\n" ++ 
  "total_weight: " ++ show(total_weight) ++ "\n"
] ++
[
   if fix(x[i]) > 0 then 
     show(items_str[i]) ++ ": " ++ show(x[i]) ++ " value: " ++ show(items[i,2]) ++ "\n"
   else 
     ""
   endif
   | i in 1..num_items

]
 ++ ["\n"]
;


%
% Data
%

items_str = 
[
"map","compass","water","sandwich","glucose","tin","banana","apple","cheese",
"beer","suntancream","camera","T-shirt","trousers","umbrella","waterproof trousers",
"waterproof overclothes","note-case","sunglasses","towel","socks","book"];


%
% weight (dag) (each)  value (each)  pieces(s)
%
items = array2d(1..num_items, 1..2, [
9,       150,
13,      35,
153,     200,
50,      160,
15,      60,
68,      45,
27,      60,
39,      40,
23,      30,
52,      10,
11,      70,
32,      30,
24,      15,
48,      10,
73,      40,
42,      70,
43,      75,
22,      80,
7,       20,
18,      12,
4,       50,
30,      10
]);