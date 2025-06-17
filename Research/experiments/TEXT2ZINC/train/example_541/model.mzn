int: m = 5300;
var 0..m: Ph;
var 0..m: Pa;
var 0..m: Pl;
var 0..m: El;
var 0..m: Ca;
var 0..m: Ma;

solve minimize Ph+Pa+Pl+El+Ca+Ma+Pa;
% solve satisfy;

constraint
  1100 = Ph + Pa
  /\ 1700 = Pa + Pl
  /\ 1100 = Pl + El
  /\ 3300 = El + Ca
  /\ 5300 = Ca + Ma
  /\ 3200 = Ma + Pa
;

output [
 "Ph:", show(Ph), " ",
 "Pa:", show(Pa), " ",
 "Pl:", show(Pl), " ",
 "El:", show(El), " ",
 "Ca:", show(Ca), " ",
 "Ma:", show(Ma), " ", "\n",
]