var 1..50: A;
var 1..50: B;
var 1..50: C;
var 1..50: D;
var 1..50: E;
var 1..50: F;
var 1..50: G;

solve satisfy;

constraint
   A*A*A + B*B*B + C*C*C + D*D*D = E*E*E + F*F*F + G*G*G /\

   % symmetries in left side
   A <= B /\
   B <= C /\
   C <= D /\

   % symmetries in right side
   E <= F /\
   F <= G /\
 
   % and between the sides
   A <= E
;

output [
  show(A), "^3 + ",
  show(B), "^3 +",
  show(C), "^3 + ",
  show(D), "^3 = ",
  show(E), "^3 + ",
  show(F), "^3 + ",
  show(G), "^3 ","\n"
];