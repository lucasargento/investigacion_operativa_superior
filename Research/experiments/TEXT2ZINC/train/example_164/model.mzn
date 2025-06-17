predicate interval(var int: X1, var int: X2) =
  X1 < X2
;

predicate before(var int: X1, var int: X2, var int: Y1, var int: Y2) =
    interval(X1, X2) /\
    interval(Y1, Y2) /\
    X2 < Y1
;

predicate after(var int: X1, var int: X2, var int: Y1, var int: Y2) =
    before(Y1, Y2, X1, X2)
;

predicate meets(var int: X1, var int: X2, var int: Y1, var int: Y2) = 
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X2 = Y1
;

predicate met_by(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   meets(Y1, Y2, X1, X2)
;

predicate overlaps(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X1 < Y1 /\
   Y1 < X2 /\
   X2 < Y2
;

predicate overlapped_by(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   overlaps(Y1, Y2, X1, X2)
;

predicate starts(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X1 = Y1 /\
   X2 < Y2
;


predicate started_by(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   starts(Y1, Y2, X1, X2)
;

predicate during(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X1 > Y1 /\
   X2 < Y2
;

predicate contains(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   during(Y1, Y2, X1, X2)
;

predicate finishes(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X1 > Y1 /\
   X2 = Y2
;

predicate finished_by(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   finishes(Y1, Y2, X1, X2)
;

predicate equal(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   interval(X1, X2) /\
   interval(Y1, Y2) /\
   X1 = Y1 /\
   X2 = Y2
;

predicate real_overlap(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   X1 < Y2 /\ 
   Y1 < X2
;

predicate weak_overlap(var int: X1, var int: X2, var int: Y1, var int: Y2) =
   X1 <= Y2 /\ 
   Y1 <= X2
;



% solve satisfy;
solve minimize J2+W2; % minimize the time for J2 and W2

set of int: D = 0..9;
var D: J1;
var D: J2;
var D: M1;
var D: M2;
var D: B1;
var D: B2;
var D: S1;
var D: S2;
var D: W1;
var D: W2;
array[1..10] of var D: List = [J1,J2,M1,M2,B1,B2,S1,S2,W1,W2];

constraint

   %
   % The story
   % 

   % Meeting and Jones
   (J1 < M1 /\ M1 < J2)  /\

   % Meeting and White  
   overlaps(M1, M2, W1, W2) /\

   % Meeting and Smith
   real_overlap(M1, M2, S1, S2)  /\

   % Jones and Smith
   before(J1, J2, S1, S2)  /\

   % Brown and Smith
   real_overlap(B1, B2, S1, S2) /\

   % Brown and White
   real_overlap(B1, B2, W1, W2) /\

   % Smith and White
   real_overlap(S1, S2, W1, W2) /\

   % "Could possibly Jones and White have talked during this meeting?"
   weak_overlap(J1, J2, W1, W2)

   % /\ List = [0,2,1,4,0,4,3,4,2,5]
   % /\ List = [0,3,1,5,0,5,4,5,2,6] % Apt's solution in the presentation
;


output [
 "J1,J2,M1,M2,B1,B2,S1,S2,W1,W2:\n" ++
 show(List), "\n",
 "[J1,J2]: ", show([J1,J2]),"\n",
 "[W1,W2]: ", show([W1,W2]),"\n",
]
;