include "globals.mzn"; 

int: n; % total number of currencies
int: m; % number of involved currencies
array[1..n,1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

% decision variables
array[1..m+1] of var 0..n: y; % currency to use
array[1..m+1] of var 0.0..max(array1d(currencies)): profit;


% var 0.0..1000000.0: z;
var float: z;

solve maximize z;
% solve :: float_search(y ++ profit,0.1, input_order, indomain_split, complete) maximize z;

constraint
  z >= 0.0 /\
  all_different([y[i] | i in 1..m]) /\
  y[1] = y[m+1] /\
  forall(i in 1..m) (
     profit[i] = currencies[y[i],y[i+1]]
  )
  /\
  z = product([profit[i] | i in 1..m])
;

output [
  "z: \(z)\n",
  "profit: \([profit[i] | i in 1..m])\n",
  "y: \(y)\n",
  "starts with \(start) \(currencies_s[fix(y[1])]) -> \(start*z) \(currencies_s[fix(y[1])])\n",
  "real profit: \(start*z) - \(start) = \(start*z - start) \(currencies_s[fix(y[1])])\n\n",
]
++
[
  "\(currencies_s[fix(y[i])]) -> \(currencies_s[fix(y[i+1])]) \(profit[i])\n"
  | i in 1..m
]
;


%% From the example above:
%%  Trade $100 to €77.79
%%  Trade €77.79 to .8751375 BTC
%%  Trade .8751375 BTC for $101.20965.
%%
%%  USD  EUR     JPY            BTC
% n = 4;
% m = 4;
% start = 1000.0;
% currencies = array2d(1..n,1..n,
% [
% 0,      0.7779,  102.4590,  0.0083,
% 1.2851, 0,       131.7110,  0.01125,
% 0.0098, 0.0075,  0,         0.0000811,
% 115.65, 88.8499, 12325.44,  0,
% ]);
% currencies_s = ["USD","EUR","JPY","BTC"];