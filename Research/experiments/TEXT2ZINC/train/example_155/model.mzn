include "globals.mzn"; 

int: n; 
set of int: nDomain = 0..n-1;

array[nDomain, nDomain] of var nDomain: quasiGroup;

solve :: int_search([quasiGroup[row, col] | row, col in nDomain], 
        first_fail, indomain_min, complete) satisfy;
% solve satisfy;

constraint
     
     % assign the "reflected" quasigroup to qGColumns to access its columns
     %  forall row,col : nDomain .
     %    quasiGroupColumns[col,row] = quasiGroup[row,col],

     % All rows have to be different
     forall(row in nDomain) (
          all_different([quasiGroup[row,col] | col in nDomain])
     )
     /\
     % all values in the diagonals
     forall( i in nDomain ) (
          quasiGroup[i,i] = i
     )
     /\

     % All columns have to be different	       
     forall(col in nDomain) (
          all_different([quasiGroup[row, col] | row in nDomain])
     )
     /\

     % this strange constraint
     % corresponds to:
     % quasiGroup[i, quasiGroup[j,i]] = quasiGroup[quasiGroup[j,i], j]	
     forall(i,j in nDomain) (
              quasiGroup[i, quasiGroup[j,i]] = quasiGroup[quasiGroup[j,i],j]
     )
     /\
     % some implied? constraint
     forall(i in nDomain) (
           quasiGroup[i,n-1] + 2 >= i
     )
;

output [
  if col = 0 then "\n" else " " endif ++
    show(quasiGroup[row, col])
  | row, col in nDomain
] ++ ["\n"];


%
% data
%
n = 5;