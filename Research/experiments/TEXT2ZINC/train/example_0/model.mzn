% 
% P-median problem in MiniZinc.
% 
% 
% Model and data from the OPL Manual, which describes the problem:
% """
% The P-Median problem is a well known problem in Operations Research. 
% The problem can be stated very simply, like this: given a set of customers 
% with known amounts of demand, a set of candidate locations for warehouses, 
% and the distance between each pair of customer-warehouse, choose P 
% warehouses to open that minimize the demand-weighted distance of serving 
% all customers from those P warehouses.
% """

% Compare with the Comet model:
% http://www.hakank.org/comet/p_median.co
%
% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

% include "globals.mzn"; 

int: P;
int: num_customers;
set of int: Customers = 1..num_customers;

int: num_warehouses;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;

array[Customers, Warehouses] of float: Distance;

% decision variables
array[Warehouses] of var 0..1: OpenWarehouse;
array[Customers,Warehouses] of var 0..1: ShipToCustomer;

var float: z =   sum(c in Customers, w in Warehouses) (
     Demand[c]*Distance[c,w]*int2float(ShipToCustomer[c,w])
    );

solve minimize z;

constraint
  forall(c in Customers) (
    sum(w in Warehouses) (ShipToCustomer[c,w]) = 1
  )
  /\
  sum(OpenWarehouse) = P
  /\
  forall( c in Customers , w in Warehouses ) (
    ShipToCustomer[c,w] <= OpenWarehouse[w]
  )

;

output [
"OpenWarehouse: " ++ show(OpenWarehouse) ++ "\n"++
"ShipToCustomer: " ++ show(ShipToCustomer) ++ "\n"++
"z: " ++ show(z) ++ "\n"
];
