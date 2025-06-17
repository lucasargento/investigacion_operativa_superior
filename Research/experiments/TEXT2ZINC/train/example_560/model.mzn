include "globals.mzn"; 

int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% decision variables
array[1..num_parts] of var 1..num_stores: x; % which store to by product p?

var 0.0..max(array1d(product_stores)): part_cost; 
var 0.0..max(store_delivery_costs): delivery_cost;
var float: total_cost = part_cost + delivery_cost;

solve minimize total_cost;
% solve :: int_search(x, first_fail, indomain_min, complete) satisfy;

constraint

  total_cost >= 0.0 /\

  % a selected part must be in an available store
  forall(p in 1..num_parts) (
     % note: " ... > 0" don't work, must be greater than 0
     product_stores[p,x[p]] > 0.01
  )
  /\

  % total cost for the parts
  part_cost = sum([product_stores[p,x[p]] | p in 1..num_parts])
  /\

  % the delivery cost
  delivery_cost = sum([
                    % is there something bought from shop s?
                    if sum([x[p] = s | p in 1..num_parts]) > 0 then 
                        store_delivery_costs[s] 
                    else 
                        0 
                    endif                 
                | s in 1..num_stores])
;

output 
[
 "x: \(x)\n",
 "part_cost: \(part_cost)\n",
 "delivery_cost: \(delivery_cost)\n",
 "total_cost: \(total_cost)\n",
];

num_parts = 3;
num_stores = 3;

% product_stores[p,s]: price 0.0 means that p is _not_ available at store s
product_stores = 
array2d(1..num_parts,1..num_stores,
[
0.0,  2.25, 2.9,
0.0,  3.00, 0.0,
2.0, 15.00, 7.0,
]);

store_delivery_costs = [12.56, 15.2, 33.5];