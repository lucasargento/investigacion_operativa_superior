var int: smallset;
var int: largeset;

solve maximize 5*smallset + 20*largeset;

constraint
  smallset >= 0 /\ largeset >= 0 
  /\
  1*smallset + 3*largeset <= 200
  /\
  3*smallset + 2*largeset <= 160
;

output
[
  "smallset: " ++ show(smallset) ++ "\n" ++
  "largeset: " ++ show(largeset) ++ "\n"
];