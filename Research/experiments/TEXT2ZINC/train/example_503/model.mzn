solve satisfy;

int: n = 100;

constraint 1=1;

output [
   show(n-i-1) ++ " bottles of beer on the wall\n" ++
   if i < n-1 then
     show(n-i-1) ++ " bootles of beer\n" ++ "Take one down, pass it around\n"
   else "" endif
  | i in 0..n-1
];